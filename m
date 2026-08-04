Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A743F3282
	for <kvmarm@lists.linux.dev>; Tue,  4 Aug 2026 06:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785823526; cv=none; b=VNhj0fwG6oWBmm2ZZslGm696Krb0VCyKbu90n3EVqg9d9VlzdIoPLYoA/hhIs1Oe2rkRxcHAaYjqSfMIrTZggjG+6Xy3S2v2wKv0SsdmfI80nx2/pZT+nHJBnmnVVq1v5p1Y8ir05oD+GzDjIfm1/ZlUWIcRnKxBovNvnOnXzWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785823526; c=relaxed/simple;
	bh=zT/j1ZK7VbIRXISjqUNKcIXA6iytR2imSXKLxEaGYaw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lw/vVSQT0tX6lhlTGDyQMtKS2EmjCOi8sh50zi4i4eBOEjj7pNVCd5Ndt1kZnDOyxuZPcx6h1D/GJaC4y/A6oxKtN4X32eTR3E2a1ylAPqnUaSwopcxPCmHP0UYsm4ZlknDVRjvp4pfU1BXSEUyNSAo4wVjG3ETTaFGktCIUZY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9TDYf4o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9TDYf4o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785823522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5C39XZlKA8sRd6as4nSyGqgfO39xi48ZF2JzZQx7zi8=;
	b=g9TDYf4oHg5Ty4zV7m2VTUtLi0OYFpsqBiKs+9Qg4WX+e0/3qhtlrx05bm6VKzoADjTgas
	zegPVNJioYe0gv4XxmDGv0hIEiiONBVK4+McOdsKIsfNAz9SZZq8yLj06WJo9pD4tOlvvk
	5cFKeeswOrUO27sxXiCMczqK3dPuDyI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-3A4D_P6BNPi79zop6tVQUw-1; Tue,
 04 Aug 2026 02:05:19 -0400
X-MC-Unique: 3A4D_P6BNPi79zop6tVQUw-1
X-Mimecast-MFC-AGG-ID: 3A4D_P6BNPi79zop6tVQUw_1785823517
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A2751956096;
	Tue,  4 Aug 2026 06:05:16 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7456118004AD;
	Tue,  4 Aug 2026 06:05:15 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DC81321E6920; Tue, 04 Aug 2026 08:05:12 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,  "qemu-arm@nongnu.org"
 <qemu-arm@nongnu.org>,  "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
  "eric.auger@redhat.com" <eric.auger@redhat.com>,  "cohuck@redhat.com"
 <cohuck@redhat.com>,  "peter.maydell@linaro.org"
 <peter.maydell@linaro.org>,  "richard.henderson@linaro.org"
 <richard.henderson@linaro.org>,  "maz@kernel.org" <maz@kernel.org>,
  "oliver.upton@linux.dev" <oliver.upton@linux.dev>,  "berrange@redhat.com"
 <berrange@redhat.com>,  "abologna@redhat.com" <abologna@redhat.com>,
  "jdenemar@redhat.com" <jdenemar@redhat.com>,  "gshan@redhat.com"
 <gshan@redhat.com>,  "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
  "sebott@redhat.com" <sebott@redhat.com>,  "philmd@linaro.org"
 <philmd@linaro.org>,  "yangjinqian1@huawei.com" <yangjinqian1@huawei.com>,
  Shaju Abraham <shaju.abraham@nutanix.com>,  Mark Cave-Ayland
 <mark.caveayland@nutanix.com>,  Prerna Saxena <prerna.saxena@nutanix.com>
Subject: Re: [RFC PATCH v3 16/19] qmp: add query-cpu-props-info command
In-Reply-To: <6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com> (Khushit
	Shah's message of "Mon, 3 Aug 2026 16:05:42 +0000")
References: <20260716213858.609699-1-khushit.shah@nutanix.com>
	<20260716213858.609699-17-khushit.shah@nutanix.com>
	<87y0f5u78t.fsf@pond.sub.org>
	<6AA3BD42-9596-476B-9F64-AB09372821B9@nutanix.com>
Date: Tue, 04 Aug 2026 08:05:12 +0200
Message-ID: <87tspa5skn.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: fOFwJnfwjDvNA6fyG4XrVpNGx9WQZ8k-K_vt1cHihkM_1785823517
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Khushit Shah <khushit.shah@nutanix.com> writes:

>> On 20 Jul 2026, at 6:51=E2=80=AFPM, Markus Armbruster <armbru@redhat.com=
> wrote:
>>=20
>> !-------------------------------------------------------------------|
>>  CAUTION: External Email
>>=20
>> |-------------------------------------------------------------------!
>>=20
>> Series doesn't apply for me.  I need to apply it to be able to check
>> rendered documentation.  Could you push it somewhere I can pull?
>>=20
>
> Sorry for the late reply,=20
> Please use the following branch: https://github.com/khushit-shah-nx/qemu/=
tree/upstream-rfc-v3-fixups

Doesn't compile for me:

FAILED: [code=3D1] qemu-aarch64_be=20
cc -m64  -o qemu-aarch64_be libcommon.a.p/accel_accel-common.c.o libcommon.=
a.p/hw_core_cpu-common.c.o libcommon.a.p/hw_core_machine-smp.c.o libcommon.=
a.p/cpu-common.c.o libcommon.a.p/page-vary-common.c.o libcommon.a.p/target-=
info.c.o libcommon.a.p/disas_capstone.c.o libcommon.a.p/disas_disas-host.c.=
o libcommon.a.p/disas_disas-target.c.o libcommon.a.p/disas_objdump.c.o libc=
ommon.a.p/disas_disas-common.c.o libcommon.a.p/fpu_softfloat.c.o libcommon.=
a.p/plugins_loader.c.o libcommon.a.p/meson-generated_.._gdbstub_gdbstub-xml=
.c.o libcommon_arm.a.p/target_arm_mmuidx.c.o libcommon_arm.a.p/target_arm_t=
cg_arith_helper.c.o libcommon_arm.a.p/target_arm_tcg_crypto_helper.c.o libu=
ser.a.p/semihosting_user.c.o libuser.a.p/semihosting_guestfd.c.o libuser.a.=
p/accel_accel-user.c.o libuser.a.p/accel_tcg_cpu-exec.c.o libuser.a.p/accel=
_tcg_cpu-exec-common.c.o libuser.a.p/accel_tcg_tcg-runtime.c.o libuser.a.p/=
accel_tcg_tcg-runtime-gvec.c.o libuser.a.p/accel_tcg_tb-maint.c.o libuser.a=
.p/accel_tcg_tcg-all.c.o libuser.a.p/accel_tcg_tcg-stats.c.o libuser.a.p/ac=
cel_tcg_translate-all.c.o libuser.a.p/accel_tcg_translator.c.o libuser.a.p/=
accel_tcg_plugin-gen.c.o libuser.a.p/accel_tcg_user-exec.c.o libuser.a.p/ac=
cel_tcg_user-exec-stub.c.o libuser.a.p/hw_core_cpu-user.c.o libuser.a.p/hw_=
core_qdev-user.c.o libuser.a.p/gdbstub_gdbstub.c.o libuser.a.p/gdbstub_sysc=
alls.c.o libuser.a.p/gdbstub_user.c.o libuser.a.p/cpu-target.c.o libuser.a.=
p/tcg_optimize.c.o libuser.a.p/tcg_region.c.o libuser.a.p/tcg_tcg.c.o libus=
er.a.p/tcg_tcg-common.c.o libuser.a.p/tcg_tcg-op.c.o libuser.a.p/tcg_tcg-op=
-ldst.c.o libuser.a.p/tcg_tcg-op-gvec.c.o libuser.a.p/tcg_tcg-op-vec.c.o li=
buser.a.p/tcg_debuginfo.c.o libuser.a.p/tcg_perf.c.o libuser.a.p/plugins_us=
er.c.o libuser.a.p/plugins_api-user.c.o libuser.a.p/plugins_api.c.o libuser=
.a.p/plugins_core.c.o libuser.a.p/common-user_safe-syscall.S.o libuser.a.p/=
common-user_safe-syscall-error.c.o libqemu-aarch64_be-linux-user.a.p/target=
_arm_gdbstub.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_cpu.c.o libqe=
mu-aarch64_be-linux-user.a.p/target_arm_cpregs-gcs.c.o libqemu-aarch64_be-l=
inux-user.a.p/target_arm_cpregs-pmu.c.o libqemu-aarch64_be-linux-user.a.p/t=
arget_arm_debug_helper.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_hel=
per.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_vfp_fpscr.c.o libqemu-=
aarch64_be-linux-user.a.p/target_arm_el2-stubs.c.o libqemu-aarch64_be-linux=
-user.a.p/target_arm_cpregs-omap-stub.c.o libqemu-aarch64_be-linux-user.a.p=
/target_arm_common-semi-target.c.o libqemu-aarch64_be-linux-user.a.p/target=
_arm_tcg_debug.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_gengvec=
.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_hflags.c.o libqemu-aa=
rch64_be-linux-user.a.p/target_arm_tcg_m_helper.c.o libqemu-aarch64_be-linu=
x-user.a.p/target_arm_tcg_mve_helper.c.o libqemu-aarch64_be-linux-user.a.p/=
target_arm_tcg_neon_helper.c.o libqemu-aarch64_be-linux-user.a.p/target_arm=
_tcg_op_helper.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_tlb_hel=
per.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_translate.c.o libq=
emu-aarch64_be-linux-user.a.p/target_arm_tcg_translate-m-nocp.c.o libqemu-a=
arch64_be-linux-user.a.p/target_arm_tcg_translate-mve.c.o libqemu-aarch64_b=
e-linux-user.a.p/target_arm_tcg_translate-neon.c.o libqemu-aarch64_be-linux=
-user.a.p/target_arm_tcg_translate-vfp.c.o libqemu-aarch64_be-linux-user.a.=
p/target_arm_tcg_vec_helper.c.o libqemu-aarch64_be-linux-user.a.p/target_ar=
m_tcg_vfp_helper.c.o libqemu-aarch64_be-linux-user.a.p/linux-user_aarch64_c=
pu_loop.c.o libqemu-aarch64_be-linux-user.a.p/linux-user_aarch64_elfload.c.=
o libqemu-aarch64_be-linux-user.a.p/linux-user_aarch64_signal.c.o libqemu-a=
arch64_be-linux-user.a.p/target-info-stub.c.o libqemu-aarch64_be-linux-user=
.a.p/target_arm_cpu64.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_gdbs=
tub64.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_cpu32.c.o libqem=
u-aarch64_be-linux-user.a.p/target_arm_tcg_cpu64.c.o libqemu-aarch64_be-lin=
ux-user.a.p/target_arm_tcg_gengvec64.c.o libqemu-aarch64_be-linux-user.a.p/=
target_arm_tcg_translate-a64.c.o libqemu-aarch64_be-linux-user.a.p/target_a=
rm_tcg_translate-sve.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_t=
ranslate-sme.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_helper-a6=
4.c.o libqemu-aarch64_be-linux-user.a.p/target_arm_tcg_mte_helper.c.o libqe=
mu-aarch64_be-linux-user.a.p/target_arm_tcg_pauth_helper.c.o libqemu-aarch6=
4_be-linux-user.a.p/target_arm_tcg_sme_helper.c.o libqemu-aarch64_be-linux-=
user.a.p/target_arm_tcg_sve_helper.c.o libqemu-aarch64_be-linux-user.a.p/ta=
rget_arm_tcg_vec_helper64.c.o libqemu-aarch64_be-linux-user.a.p/semihosting=
_syscalls.c.o libqemu-aarch64_be-linux-user.a.p/semihosting_arm-compat-semi=
.c.o libqemu-aarch64_be-linux-user.a.p/accel_accel-target.c.o libqemu-aarch=
64_be-linux-user.a.p/hw_intc_arm_gicv3_hvf_stub.c.o libqemu-aarch64_be-linu=
x-user.a.p/gdbstub_user-target.c.o libqemu-aarch64_be-linux-user.a.p/linux-=
user_elfload.c.o libqemu-aarch64_be-linux-user.a.p/linux-user_exit.c.o libq=
emu-aarch64_be-linux-user.a.p/linux-user_fd-trans.c.o libqemu-aarch64_be-li=
nux-user.a.p/linux-user_linuxload.c.o libqemu-aarch64_be-linux-user.a.p/lin=
ux-user_main.c.o libqemu-aarch64_be-linux-user.a.p/linux-user_mmap.c.o libq=
emu-aarch64_be-linux-user.a.p/linux-user_signal.c.o libqemu-aarch64_be-linu=
x-user.a.p/linux-user_strace.c.o libqemu-aarch64_be-linux-user.a.p/linux-us=
er_syscall.c.o libqemu-aarch64_be-linux-user.a.p/linux-user_thunk.c.o libqe=
mu-aarch64_be-linux-user.a.p/linux-user_uaccess.c.o libqemu-aarch64_be-linu=
x-user.a.p/linux-user_uname.c.o libqemu-aarch64_be-linux-user.a.p/linux-use=
r_flatload.c.o libqemu-aarch64_be-linux-user.a.p/linux-user_semihost.c.o li=
bqemu-aarch64_be-linux-user.a.p/linux-user_plugin-api.c.o libqemu-aarch64_b=
e-linux-user.a.p/linux-user_aarch64_mte_user_helper.c.o libhwcore.a.p/hw_co=
re_bus.c.o libhwcore.a.p/hw_core_gpio.c.o libhwcore.a.p/hw_core_qdev-proper=
ties.c.o libhwcore.a.p/hw_core_qdev.c.o libhwcore.a.p/hw_core_resetcontaine=
r.c.o libhwcore.a.p/hw_core_resettable.c.o libhwcore.a.p/hw_core_vmstate-if=
.c.o libhwcore.a.p/hw_core_irq.c.o libhwcore.a.p/hw_core_clock.c.o libhwcor=
e.a.p/hw_core_qdev-clock.c.o libqom.a.p/qom_container.c.o libqom.a.p/qom_ob=
ject.c.o libqom.a.p/qom_object_interfaces.c.o libqom.a.p/qom_qom-qobject.c.=
o libqom.a.p/qom_compat-properties.c.o libevent-loop-base.a.p/event-loop-ba=
se.c.o -Wl,--as-needed -Wl,--no-undefined -pie -fstack-protector-strong -Wl=
,-z,relro -Wl,-z,now -Wl,--start-group libqemuutil.a subprojects/libvhost-u=
ser/libvhost-user-glib.a subprojects/libvhost-user/libvhost-user.a libstubs=
_arm.a -Xlinker --dynamic-list=3D/work/armbru/qemu/bld/plugins/qemu-plugin.=
symbols /usr/lib64/libcapstone.so /usr/lib64/libz.so /usr/lib64/libdw.so /u=
sr/lib64/libelf.so -lnuma /usr/lib64/liburing.so /usr/lib64/libgio-2.0.so /=
usr/lib64/libgobject-2.0.so /usr/lib64/libglib-2.0.so /usr/lib64/libgmodule=
-2.0.so -pthread /usr/lib64/libgnutls.so -lm /usr/lib64/libpixman-1.so /usr=
/lib64/libepoxy.so -Wl,--end-group
/usr/bin/ld: libqemu-aarch64_be-linux-user.a.p/target_arm_cpu64.c.o: in fun=
ction `arm_cpu_sve_finalize':
/work/armbru/qemu/bld/../target/arm/cpu64.c:146:(.text+0x11f2): undefined r=
eference to `arm_find_model'
/usr/bin/ld: libqemu-aarch64_be-linux-user.a.p/target_arm_cpu64.c.o: in fun=
ction `arm_cpu_pauth_finalize':
/work/armbru/qemu/bld/../target/arm/cpu64.c:583:(.text+0x1a55): undefined r=
eference to `arm_find_model'
collect2: error: ld returned 1 exit status
[6689/7247] Linking target qemu-aarch64
FAILED: [code=3D1] qemu-aarch64=20
cc -m64  -o qemu-aarch64 libcommon.a.p/accel_accel-common.c.o libcommon.a.p=
/hw_core_cpu-common.c.o libcommon.a.p/hw_core_machine-smp.c.o libcommon.a.p=
/cpu-common.c.o libcommon.a.p/page-vary-common.c.o libcommon.a.p/target-inf=
o.c.o libcommon.a.p/disas_capstone.c.o libcommon.a.p/disas_disas-host.c.o l=
ibcommon.a.p/disas_disas-target.c.o libcommon.a.p/disas_objdump.c.o libcomm=
on.a.p/disas_disas-common.c.o libcommon.a.p/fpu_softfloat.c.o libcommon.a.p=
/plugins_loader.c.o libcommon.a.p/meson-generated_.._gdbstub_gdbstub-xml.c.=
o libcommon_arm.a.p/target_arm_mmuidx.c.o libcommon_arm.a.p/target_arm_tcg_=
arith_helper.c.o libcommon_arm.a.p/target_arm_tcg_crypto_helper.c.o libuser=
.a.p/semihosting_user.c.o libuser.a.p/semihosting_guestfd.c.o libuser.a.p/a=
ccel_accel-user.c.o libuser.a.p/accel_tcg_cpu-exec.c.o libuser.a.p/accel_tc=
g_cpu-exec-common.c.o libuser.a.p/accel_tcg_tcg-runtime.c.o libuser.a.p/acc=
el_tcg_tcg-runtime-gvec.c.o libuser.a.p/accel_tcg_tb-maint.c.o libuser.a.p/=
accel_tcg_tcg-all.c.o libuser.a.p/accel_tcg_tcg-stats.c.o libuser.a.p/accel=
_tcg_translate-all.c.o libuser.a.p/accel_tcg_translator.c.o libuser.a.p/acc=
el_tcg_plugin-gen.c.o libuser.a.p/accel_tcg_user-exec.c.o libuser.a.p/accel=
_tcg_user-exec-stub.c.o libuser.a.p/hw_core_cpu-user.c.o libuser.a.p/hw_cor=
e_qdev-user.c.o libuser.a.p/gdbstub_gdbstub.c.o libuser.a.p/gdbstub_syscall=
s.c.o libuser.a.p/gdbstub_user.c.o libuser.a.p/cpu-target.c.o libuser.a.p/t=
cg_optimize.c.o libuser.a.p/tcg_region.c.o libuser.a.p/tcg_tcg.c.o libuser.=
a.p/tcg_tcg-common.c.o libuser.a.p/tcg_tcg-op.c.o libuser.a.p/tcg_tcg-op-ld=
st.c.o libuser.a.p/tcg_tcg-op-gvec.c.o libuser.a.p/tcg_tcg-op-vec.c.o libus=
er.a.p/tcg_debuginfo.c.o libuser.a.p/tcg_perf.c.o libuser.a.p/plugins_user.=
c.o libuser.a.p/plugins_api-user.c.o libuser.a.p/plugins_api.c.o libuser.a.=
p/plugins_core.c.o libuser.a.p/common-user_safe-syscall.S.o libuser.a.p/com=
mon-user_safe-syscall-error.c.o libqemu-aarch64-linux-user.a.p/target_arm_g=
dbstub.c.o libqemu-aarch64-linux-user.a.p/target_arm_cpu.c.o libqemu-aarch6=
4-linux-user.a.p/target_arm_cpregs-gcs.c.o libqemu-aarch64-linux-user.a.p/t=
arget_arm_cpregs-pmu.c.o libqemu-aarch64-linux-user.a.p/target_arm_debug_he=
lper.c.o libqemu-aarch64-linux-user.a.p/target_arm_helper.c.o libqemu-aarch=
64-linux-user.a.p/target_arm_vfp_fpscr.c.o libqemu-aarch64-linux-user.a.p/t=
arget_arm_el2-stubs.c.o libqemu-aarch64-linux-user.a.p/target_arm_cpregs-om=
ap-stub.c.o libqemu-aarch64-linux-user.a.p/target_arm_common-semi-target.c.=
o libqemu-aarch64-linux-user.a.p/target_arm_tcg_debug.c.o libqemu-aarch64-l=
inux-user.a.p/target_arm_tcg_gengvec.c.o libqemu-aarch64-linux-user.a.p/tar=
get_arm_tcg_hflags.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_m_help=
er.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_mve_helper.c.o libqemu=
-aarch64-linux-user.a.p/target_arm_tcg_neon_helper.c.o libqemu-aarch64-linu=
x-user.a.p/target_arm_tcg_op_helper.c.o libqemu-aarch64-linux-user.a.p/targ=
et_arm_tcg_tlb_helper.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_tra=
nslate.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_translate-m-nocp.c=
.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_translate-mve.c.o libqemu-=
aarch64-linux-user.a.p/target_arm_tcg_translate-neon.c.o libqemu-aarch64-li=
nux-user.a.p/target_arm_tcg_translate-vfp.c.o libqemu-aarch64-linux-user.a.=
p/target_arm_tcg_vec_helper.c.o libqemu-aarch64-linux-user.a.p/target_arm_t=
cg_vfp_helper.c.o libqemu-aarch64-linux-user.a.p/linux-user_aarch64_cpu_loo=
p.c.o libqemu-aarch64-linux-user.a.p/linux-user_aarch64_elfload.c.o libqemu=
-aarch64-linux-user.a.p/linux-user_aarch64_signal.c.o libqemu-aarch64-linux=
-user.a.p/target-info-stub.c.o libqemu-aarch64-linux-user.a.p/target_arm_cp=
u64.c.o libqemu-aarch64-linux-user.a.p/target_arm_gdbstub64.c.o libqemu-aar=
ch64-linux-user.a.p/target_arm_tcg_cpu32.c.o libqemu-aarch64-linux-user.a.p=
/target_arm_tcg_cpu64.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_gen=
gvec64.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_translate-a64.c.o =
libqemu-aarch64-linux-user.a.p/target_arm_tcg_translate-sve.c.o libqemu-aar=
ch64-linux-user.a.p/target_arm_tcg_translate-sme.c.o libqemu-aarch64-linux-=
user.a.p/target_arm_tcg_helper-a64.c.o libqemu-aarch64-linux-user.a.p/targe=
t_arm_tcg_mte_helper.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_paut=
h_helper.c.o libqemu-aarch64-linux-user.a.p/target_arm_tcg_sme_helper.c.o l=
ibqemu-aarch64-linux-user.a.p/target_arm_tcg_sve_helper.c.o libqemu-aarch64=
-linux-user.a.p/target_arm_tcg_vec_helper64.c.o libqemu-aarch64-linux-user.=
a.p/semihosting_syscalls.c.o libqemu-aarch64-linux-user.a.p/semihosting_arm=
-compat-semi.c.o libqemu-aarch64-linux-user.a.p/accel_accel-target.c.o libq=
emu-aarch64-linux-user.a.p/hw_intc_arm_gicv3_hvf_stub.c.o libqemu-aarch64-l=
inux-user.a.p/gdbstub_user-target.c.o libqemu-aarch64-linux-user.a.p/linux-=
user_elfload.c.o libqemu-aarch64-linux-user.a.p/linux-user_exit.c.o libqemu=
-aarch64-linux-user.a.p/linux-user_fd-trans.c.o libqemu-aarch64-linux-user.=
a.p/linux-user_linuxload.c.o libqemu-aarch64-linux-user.a.p/linux-user_main=
.c.o libqemu-aarch64-linux-user.a.p/linux-user_mmap.c.o libqemu-aarch64-lin=
ux-user.a.p/linux-user_signal.c.o libqemu-aarch64-linux-user.a.p/linux-user=
_strace.c.o libqemu-aarch64-linux-user.a.p/linux-user_syscall.c.o libqemu-a=
arch64-linux-user.a.p/linux-user_thunk.c.o libqemu-aarch64-linux-user.a.p/l=
inux-user_uaccess.c.o libqemu-aarch64-linux-user.a.p/linux-user_uname.c.o l=
ibqemu-aarch64-linux-user.a.p/linux-user_flatload.c.o libqemu-aarch64-linux=
-user.a.p/linux-user_semihost.c.o libqemu-aarch64-linux-user.a.p/linux-user=
_plugin-api.c.o libqemu-aarch64-linux-user.a.p/linux-user_aarch64_mte_user_=
helper.c.o libhwcore.a.p/hw_core_bus.c.o libhwcore.a.p/hw_core_gpio.c.o lib=
hwcore.a.p/hw_core_qdev-properties.c.o libhwcore.a.p/hw_core_qdev.c.o libhw=
core.a.p/hw_core_resetcontainer.c.o libhwcore.a.p/hw_core_resettable.c.o li=
bhwcore.a.p/hw_core_vmstate-if.c.o libhwcore.a.p/hw_core_irq.c.o libhwcore.=
a.p/hw_core_clock.c.o libhwcore.a.p/hw_core_qdev-clock.c.o libqom.a.p/qom_c=
ontainer.c.o libqom.a.p/qom_object.c.o libqom.a.p/qom_object_interfaces.c.o=
 libqom.a.p/qom_qom-qobject.c.o libqom.a.p/qom_compat-properties.c.o libeve=
nt-loop-base.a.p/event-loop-base.c.o -Wl,--as-needed -Wl,--no-undefined -pi=
e -fstack-protector-strong -Wl,-z,relro -Wl,-z,now -Wl,--start-group libqem=
uutil.a subprojects/libvhost-user/libvhost-user-glib.a subprojects/libvhost=
-user/libvhost-user.a libstubs_arm.a -Xlinker --dynamic-list=3D/work/armbru=
/qemu/bld/plugins/qemu-plugin.symbols /usr/lib64/libcapstone.so /usr/lib64/=
libz.so /usr/lib64/libdw.so /usr/lib64/libelf.so -lnuma /usr/lib64/liburing=
.so /usr/lib64/libgio-2.0.so /usr/lib64/libgobject-2.0.so /usr/lib64/libgli=
b-2.0.so /usr/lib64/libgmodule-2.0.so -pthread /usr/lib64/libgnutls.so -lm =
/usr/lib64/libpixman-1.so /usr/lib64/libepoxy.so -Wl,--end-group
/usr/bin/ld: libqemu-aarch64-linux-user.a.p/target_arm_cpu64.c.o: in functi=
on `arm_cpu_sve_finalize':
/work/armbru/qemu/bld/../target/arm/cpu64.c:146:(.text+0x11f2): undefined r=
eference to `arm_find_model'
/usr/bin/ld: libqemu-aarch64-linux-user.a.p/target_arm_cpu64.c.o: in functi=
on `arm_cpu_pauth_finalize':
/work/armbru/qemu/bld/../target/arm/cpu64.c:583:(.text+0x1a55): undefined r=
eference to `arm_find_model'
collect2: error: ld returned 1 exit status

