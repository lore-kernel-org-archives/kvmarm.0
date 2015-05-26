From: Pavel Fedin <p.fedin@samsung.com>
Subject: Re: [PATCH v3 4/4] target-arm: Add the GICv2m to
 the	virt board
Date: Tue, 26 May 2015 16:54:17 +0300
Message-ID: <019801d097bb$75764c70$6062e550$@samsung.com>
References: <1432464666-4825-1-git-send-email-christoffer.dall@linaro.org>
	<1432464666-4825-5-git-send-email-christoffer.dall@linaro.org>
	<55646D0F.9040801@linaro.org>
	<CAFEAcA-NVfKXNOUo=3Li298wys-KFw1Vn9mVHbh+bc0aJ2efEQ@mail.gmail.com>
	<5564702F.2030308@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-reply-to: <5564702F.2030308@linaro.org>
Content-language: ru
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: 'Eric Auger' <eric.auger@linaro.org>, 'Peter Maydell' <peter.maydell@linaro.org>
Cc: 'QEMU Developers' <qemu-devel@nongnu.org>, 'Christoffer Dall' <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

 Hi! My word...

> What is your guidance, should we introduce new memory maps for GICv3
> enabled machine or should we move to a single dynamic memory map?

 IMHO there's no reason to introduce another memory map. I have already =
done test integration some time ago, and here is what i got:
--- cut ---
enum {
    VIRT_FLASH,
    VIRT_MEM,
    VIRT_CPUPERIPHS,
    VIRT_GIC_DIST,
    VIRT_GIC_CPU,
    VIRT_GIC_DIST_SPI =3D VIRT_GIC_CPU,
    VIRT_ITS_CONTROL,
    VIRT_ITS_TRANSLATION,
    VIRT_LPI,
    VIRT_UART,
    VIRT_MMIO,
    VIRT_RTC,
    VIRT_FW_CFG,
    VIRT_PCIE,
    VIRT_GIC_V2M =3D VIRT_ITS_CONTROL,
};
--- cut ---
static const MemMapEntry a15memmap[] =3D {
    /* Space up to 0x8000000 is reserved for a boot ROM */
    [VIRT_FLASH] =3D           {          0, 0x08000000 },
    [VIRT_CPUPERIPHS] =3D      { 0x08000000, 0x00020000 },
    /* GIC distributor and CPU interfaces sit inside the CPU peripheral =
space */
    [VIRT_GIC_DIST] =3D        { 0x08000000, 0x00010000 },
    [VIRT_GIC_CPU] =3D         { 0x08010000, 0x00010000 }, /* =
VIRT_GIC_DIST_SPI for v3 */
    [VIRT_ITS_CONTROL] =3D     { 0x08020000, 0x0010000 }, /* =
VIRT_GIC_V2M for v2 */
    [VIRT_ITS_TRANSLATION] =3D { 0x08030000, 0x00010000 },
    [VIRT_LPI] =3D             { 0x08040000, 0x00800000 },
    [VIRT_UART] =3D            { 0x09000000, 0x00001000 },
    [VIRT_RTC] =3D             { 0x09010000, 0x00001000 },
    [VIRT_FW_CFG] =3D          { 0x09020000, 0x0000000a },
    [VIRT_MMIO] =3D            { 0x0a000000, 0x00000200 },
    /* ...repeating for a total of NUM_VIRTIO_TRANSPORTS, each of that =
size */
    /*
     * PCIE verbose map:
     *
     * MMIO window      { 0x10000000, 0x2eff0000 },
     * PIO window       { 0x3eff0000, 0x00010000 },
     * ECAM             { 0x3f000000, 0x01000000 },
     */
    [VIRT_PCIE] =3D       { 0x10000000, 0x30000000 },
    [VIRT_MEM] =3D        { 0x40000000, 30ULL * 1024 * 1024 * 1024 },
};
--- cut ---
 As you can see, it's perfectly readable and memory maps are identical. =
I even see no problem with merging ITS_CONTROL and ITS_TRANSPATION, =
because i don't see any harm in increasing v2m area.
 P.S. And yes, VIRT_GIC_DIST_SPI should be VIRT_GIC_DIST_MBI instead =
(Reviewed-by: Eric Auger <eric.auger@linaro.org>), just this fragment is =
from my old integration branch, which i currently don't work on, because =
my new test environment doesn't use GICv2 at all.

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia
