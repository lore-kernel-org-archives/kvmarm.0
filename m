From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 3/6] hw/char: pl011 don't keep setting the IRQ if nothing changed
Date: Wed,  4 Mar 2015 14:35:50 +0000
Message-ID: <1425479753-18349-4-git-send-email-alex.bennee@linaro.org>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

While observing KVM traces I can see additional IRQ calls on pretty muc=
h
every MMIO access which is just plain inefficient. Only update the QEMU
IRQ level if something has actually changed from last time. Otherwise w=
e
may be papering over other failure modes.

Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>

diff --git a/hw/char/pl011.c b/hw/char/pl011.c
index 0a45115..bb554bc 100644
--- a/hw/char/pl011.c
+++ b/hw/char/pl011.c
@@ -36,6 +36,9 @@ typedef struct PL011State {
     CharDriverState *chr;
     qemu_irq irq;
     const unsigned char *id;
+
+    /* not serialised, prevents pl011_update doing extra set_irqs */
+    uint32_t current_irq;
 } PL011State;
=20
 #define PL011_INT_TX 0x20
@@ -53,10 +56,11 @@ static const unsigned char pl011_id_luminary[8] =3D
=20
 static void pl011_update(PL011State *s)
 {
-    uint32_t flags;
-
-    flags =3D s->int_level & s->int_enabled;
-    qemu_set_irq(s->irq, flags !=3D 0);
+    uint32_t flags =3D s->int_level & s->int_enabled;
+    if (flags !=3D s->current_irq) {
+        s->current_irq =3D flags;
+        qemu_set_irq(s->irq, s->current_irq !=3D 0);
+    }
 }
=20
 static uint64_t pl011_read(void *opaque, hwaddr offset,
--=20
2.3.1

