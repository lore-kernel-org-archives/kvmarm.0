Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B591F3FEB
	for <kvmarm@lists.linux.dev>; Sat, 15 Feb 2025 19:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739646276; cv=none; b=Qe82SvuT1WWJ5wIVwos5MHBPWiJR3iA9HTQmQYawGNGTmVPSpr6j4gP6RIQItQBl4gwo+DkmAX9gVJFjVGdTUnqUif0pPsYD3oD3XqVZcGs56lCyYJY6RtAoQUIpJk12Sr+QqxFsTfVTLtx4ciZc9qRhicKQm3KtqwP03D2FW1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739646276; c=relaxed/simple;
	bh=BNwVKSMVB4ei85gF14ckQDuvQMzrZYstkUE4Z/f3cpc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IC9tUb4IiEbkrrwlF+DVBVgsFR1KqRNHqnIhZhMwd+9hJvfVjD0/Bqe7MXmI/E97MnLkDNtC1wvhAXGYub6QOGykAUWpm9lgl/Szu0AXGBxqTl9IvFTU7taVu5Xw8NJQkSEU21tu1C6FP+aiaWtbdZuJGmQkjqFqU93BFGptboM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfAS/Fds; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfAS/Fds"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38de1a5f039so2929122f8f.2
        for <kvmarm@lists.linux.dev>; Sat, 15 Feb 2025 11:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739646273; x=1740251073; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KlKFAiXF1vqmNku37ywbRPDu9DnnoONEYBqGIA8J8Tc=;
        b=WfAS/FdsX0AnAvAYJSQS8xH5g9G1G8UkFcjAtABhW6enqQLP7KgDs9u5AAiZyMORVz
         TPkKWojELAGCKsQqNpZuEf+2Kqm9GS+IwHCpyBOUipXJ2+REAxA/rTQpe7NNa/6hYMiR
         Ac2OQJ+JxpSpz9Y41uiyrG47DBCJeD2KGRs1ZFuj8ZbOZWksHM7/e/xBkrIqlp19LPuP
         iT1/O99uOJbwos8hUBuIjPcdzqF0BUh9JMYFV/B3HOUW74E98Ps8vRQLvRKAb/VRV8VB
         wPC1/+iabpegqN4CvhVXOhbe4cL4F5QU7IV22x3532G91NK65/iiqJe7R16xKWaKt0gf
         m20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739646273; x=1740251073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KlKFAiXF1vqmNku37ywbRPDu9DnnoONEYBqGIA8J8Tc=;
        b=cWRhC/X4RtvnhZtwZWx+VM6JIm9LbyYN3QSuNWPqZZS2OyGnyBMvwcWaOZhccDFHZu
         /PElaVVLqdrXxc7g/3Twm3wdvVQMLmdqqxMn3t+WIZkI5fKLJKN0qeBKaUsxmfC9t498
         YTzy86xHRTu+0YY1n2PHTpTQ7t85ykX7BRUtrT4TnIqVqfDlRDno8HAw/QuaiMEeY1RU
         gFZWj4xqtVRxQ//81Ml3YqccFVq1VwZTqQr0KL/ukyawFMX7E+pDwHXdGE69eyiDQ7yy
         Tg+wGW4/hKKz8eSyO9yz38IF1hc+knkrkV11tPrPH5YaVlU94Aw0ezEtdbCz+vi1Zh2D
         5Z/w==
X-Forwarded-Encrypted: i=1; AJvYcCXja8HJSpqAPBGXFq5wm5Wld9IPqG+ajKfZXi8EIrhOnGtcfXVA75D5l/LJzSeDfT9tRKB0BKw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxh5BkZzyerHNPM1xUN5qCW/Xaq4dpKF+plmwriPanHLtSftTgq
	xuCn8f8YTDi3ok6XTJ5iCaN68nRo5ACg+Ya0xgUP1XmsM9Zz90jt1fy/hpgj0MaT5fcih3pEzKe
	00PtgljeMBBtU0hJaJbK3CR4YFJc=
X-Gm-Gg: ASbGncufqI4ky9Z48FmvpOn+2G5YZwvQ9VdXqcV4DT7rUpYu54ha3o7XH+Ms4WdmJjV
	KHXou03QFVndbsk0zidffgc0C9sTqRf3LKvbUbZa05Z64/O6s2HbrJO4wvtOwJIAX5yuGVVIJ
X-Google-Smtp-Source: AGHT+IEocBWSCkH48AST7THBakDBtI1P2cdLUqJH6P86HXBwtD0EzH2fLPQKQwSVk/LyuSbjXvQi9m7uLUhUvVcdzzs=
X-Received: by 2002:adf:f6c6:0:b0:38d:d371:e01d with SMTP id
 ffacd0b85a97d-38f33f565c1mr3601951f8f.49.1739646272570; Sat, 15 Feb 2025
 11:04:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250211143910.16775-1-sebott@redhat.com> <20250211143910.16775-2-sebott@redhat.com>
 <Z7BoydkyT_h0gwOV@linux.dev> <CAE2XoE_8ihJZQF856w-_F+cgJW7fLWGz7M7Ztoxzw2vE51_m1A@mail.gmail.com>
 <87v7tb17os.wl-maz@kernel.org>
In-Reply-To: <87v7tb17os.wl-maz@kernel.org>
Reply-To: luoyonggang@gmail.com
From: =?UTF-8?B?572X5YuH5YiaKFlvbmdnYW5nIEx1byk=?= <luoyonggang@gmail.com>
Date: Sun, 16 Feb 2025 03:04:20 +0800
X-Gm-Features: AWEUYZmlz4_KXFrAI2Ba46wtyq_RK2-V1RipaueUyL2YXpkrSGw8aW2NemzLpwc
Message-ID: <CAE2XoE9=hjP+qpsy+FcYcSDectDajiXjtcMCVpacSo4cFOo=tQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: arm64: Allow userspace to change MIDR_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Sebastian Ott <sebott@redhat.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, 
	Cornelia Huck <cohuck@redhat.com>, Eric Auger <eric.auger@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>
> How do you determine that MIDR isn't updated? How do you update the
> userspace view?
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

The testing code is at
https://github.com/lygstate/arm64-kvm-hello-world/tree/midr/bare-metal-aarc=
h32-qemu
qemu changes:
```
From 543f2f656952ab01509025b79d0198736ef68231 Mon Sep 17 00:00:00 2001
From: Yonggang Luo <luoyonggang@gmail.com>
Date: Sun, 16 Feb 2025 02:57:44 +0800
Subject: [PATCH] Add support midr options for arm virt machine

---
 hw/arm/virt.c         | 20 ++++++++++++++++++++
 include/hw/arm/virt.h |  1 +
 target/arm/kvm.c      | 21 +++++++++++++++++++++
 3 files changed, 42 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 4a5a9666e9..5ba690a70d 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2236,6 +2236,10 @@ static void machvirt_init(MachineState *machine)
         object_property_set_int(cpuobj, "mp-affinity",
                                 possible_cpus->cpus[n].arch_id, NULL);

+        if (vms->midr) {
+            object_property_set_int(cpuobj, "midr", vms->midr, NULL);
+        }
+
         cs =3D CPU(cpuobj);
         cs->cpu_index =3D n;

@@ -3348,6 +3352,17 @@ static const TypeInfo virt_machine_info =3D {
     },
 };

+static char * virt_get_midr(Object *obj, Error **errp)
+{
+    VirtMachineState *vms =3D VIRT_MACHINE(obj);
+    return g_strdup_printf("0x%08x", vms->midr);
+}
+static void virt_set_midr(Object *obj, const char *value, Error **errp)
+{
+    VirtMachineState *vms =3D VIRT_MACHINE(obj);
+    vms->midr =3D strtoul(value, 0, 0);
+}
+
 static void machvirt_machine_init(void)
 {
     type_register_static(&virt_machine_info);
@@ -3356,6 +3371,11 @@ type_init(machvirt_machine_init);

 static void virt_machine_10_0_options(MachineClass *mc)
 {
+    ObjectClass *oc =3D &mc->parent_class;
+    object_class_property_add_str(oc, "midr", virt_get_midr,
+        virt_set_midr);
+    object_class_property_set_description(oc, "midr",
+                "Set MDIR value for VIRT machine");
 }
 DEFINE_VIRT_MACHINE_AS_LATEST(10, 0)

diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index c8e94e6aed..fe200b0d76 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -179,6 +179,7 @@ struct VirtMachineState {
     PCIBus *bus;
     char *oem_id;
     char *oem_table_id;
+    uint32_t midr;
     bool ns_el2_virt_timer_irq;
 };

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index da30bdbb23..577eaee505 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1873,6 +1873,7 @@ static int kvm_arm_sve_set_vls(ARMCPU *cpu)
 }

 #define ARM_CPU_ID_MPIDR       3, 0, 0, 0, 5
+#define ARM_CPU_ID_MIDR_EL1    3, 0, 0, 0, 0

 int kvm_arch_init_vcpu(CPUState *cs)
 {
@@ -1920,6 +1921,26 @@ int kvm_arch_init_vcpu(CPUState *cs)
         return ret;
     }

+    {
+        uint64_t midr =3D cpu->midr;
+        ret =3D kvm_get_one_reg(cs, ARM64_SYS_REG(ARM_CPU_ID_MIDR_EL1), &m=
idr);
+        if (ret) {
+            return ret;
+        }
+        printf("Get MIDR EL1 origin:0x%08x\n", (uint32_t)midr);
+        midr =3D cpu->midr;
+        ret =3D kvm_set_one_reg(cs, ARM64_SYS_REG(ARM_CPU_ID_MIDR_EL1), &m=
idr);
+        printf("Set MIDR EL1:0x%08x\n", (uint32_t)midr);
+        if (ret) {
+            return ret;
+        }
+        ret =3D kvm_get_one_reg(cs, ARM64_SYS_REG(ARM_CPU_ID_MIDR_EL1), &m=
idr);
+        printf("Get MIDR EL1:0x%08x\n", (uint32_t)midr);
+        if (ret) {
+            return ret;
+        }
+    }
+
     if (cpu_isar_feature(aa64_sve, cpu)) {
         ret =3D kvm_arm_sve_set_vls(cpu);
         if (ret) {
--=20
2.47.1.windows.1

```
The TCG running result:
```
/home/lygstate/work/qemu/build:/usr/local/sbin:/usr/local/bin:/usr/sbin:/us=
r/bin:/sbin:/bin
/home/lygstate/work/qemu/build/qemu-system-aarch64
+ qemu-system-aarch64 -cpu cortex-a15 -accel tcg,thread=3Dmulti -m 1024M
-smp 1 -M virt,gic-version=3D3,midr=3D0x412fd050 -nographic -monitor none
-serial stdio -kernel
/home/lygstate/work/debian/arm64-kvm-hello-world/bare-metal-aarch32-qemu/he=
llo_world.elf
Hello World midr:0x412fd050
```
The KVM running result:
```
/home/lygstate/work/qemu/build:/usr/local/sbin:/usr/local/bin:/usr/sbin:/us=
r/bin:/sbin:/bin
/home/lygstate/work/qemu/build/qemu-system-aarch64
+ qemu-system-aarch64 -cpu host,aarch64=3Doff -accel kvm -m 1024M -smp 1
-M virt,gic-version=3D3,midr=3D0x412fd050 -nographic -monitor none -serial
stdio -kernel /home/lygstate/work/debian/arm64-kvm-hello-world/bare-metal-a=
arch32-qemu/hello_world.elf
Get MIDR EL1 origin:0x410fd083
Set MIDR EL1:0x412fd050
Get MIDR EL1:0x412fd050
Hello World midr:0x410fd083
```

According to this, the MIDR EL1 is updated properly, but the MIDR for
aarch32 is not updated, and I don't know how to hook the update for
MIDR for aarch32
--
         =E6=AD=A4=E8=87=B4
=E7=A4=BC
=E7=BD=97=E5=8B=87=E5=88=9A
Yours
    sincerely,
Yonggang Luo
