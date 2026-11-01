# Maintainer: gqpdx
pkgname=plm-multiscreen-wallpaper
pkgver=0.1.0
pkgrel=1
pkgdesc='Independent per-display wallpapers for Plasma Login Manager'
arch=('any')
url='https://github.com/gqpdx/plm-multiscreen-wallpaper'
license=('GPL-2.0-or-later')
depends=('plasma-login-manager')
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/gqpdx/${pkgname}/archive/refs/tags/v${pkgver}.tar.gz")
sha256sums=('SKIP')

package() {
    install -d "${pkgdir}/usr/share/plasma/wallpapers/io.github.gqpdx.plm-multiscreen-wallpaper"
    cp -a "${srcdir}/${pkgname}-${pkgver}/metadata.json" "${pkgdir}/usr/share/plasma/wallpapers/io.github.gqpdx.plm-multiscreen-wallpaper/"
    cp -a "${srcdir}/${pkgname}-${pkgver}/contents" "${pkgdir}/usr/share/plasma/wallpapers/io.github.gqpdx.plm-multiscreen-wallpaper/"
}
