Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E71392C25
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 23:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777936253; cv=none; b=E+7aRAo4dbRJ9NpQOeglnbn2Qc2Lnk62E/NhtP8Uw45yBvwrJS44Tc49p1X1OjTJG2l+EHmokjvSNYpuumCK5YOMg2mMHhL8TMDh1ZN3aSeF9S89Bc7iElgvKhK3Ujclf8vqC+DeGVk8zPPkM6JujUHUPmbJAif7Aic9BDO/VsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777936253; c=relaxed/simple;
	bh=e1v+wg5Mt+4G2ehJr+dbUseIs8rNc8zIUsahECLU2nU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Omyiowsb43KooOW1vr5homSpLjZE3Z8UVL4KwckbgX9usJBFJcZVPHn2Ek6XDmIqDrzOl6CX5brQ5r47VL0cihePacTASRPqUQcBVLDnlhOqXBTl7SPUy637g++akXr25GXFB6M0sTPr5YOY7RvWuJSuvETIHaHGNLzPs7CmNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NB58H9cV; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NB58H9cV"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso12034796a91.1
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 16:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777936250; x=1778541050; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cAttJD+RV5lk5kNpW7EPj87JP+4oaqPyp5frl0M0LOQ=;
        b=NB58H9cVRbZZCapv5K225e3PrmHwwHFPhInjT6e/cAs67xzuAPdHcQ+CS3q9MKby67
         sey6/yPv6FhC8R+Ta/+dl+fP+wRlbV+3HehpfjeoTJBx6xxS57EnrJ9uGf+eycev51A3
         lBKGOvkanMRDGkOSqTyy1k4Py+J5hh71mC/R4KQYCEaC3CZr6j/86rrfAo7zMwKf8SE5
         MftVWDcbyF/w78dwAMM7GmjIQ/OYzycJ+8Qp58celuK0na+avHMSFWICE0bRI6wQkI6H
         w6EDK+Srd9Xptfg7j84ig3KiCRdd7sJzxw8E4o7Jy6WWFAuqslq3dziNgxQLy+FjzGWq
         CAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777936250; x=1778541050;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cAttJD+RV5lk5kNpW7EPj87JP+4oaqPyp5frl0M0LOQ=;
        b=hGEhO2EVCNjZJl/Lo5/d2sK5Fh0H5RYfmhEE+wbWhgK+9lt7h3XWf9mHLuCjMgkEYn
         J5db54UQyrcERTy3yk1SS6NfGn0QqIEq23xJ9YmAOAPQctzr6RqEI7PXhVLzQ1ufAD/+
         48VViujKyFlTI37hjz9IsYzCK0WMTiec9o9UVGQ085BqsiPzEkjdT6Uzo4tPMpEu09WH
         cM8Y/rmeHYTmvYgHtrpCSI/QsThuXkUOrbGdWc0pPKYRXCeAiw/ypPdQ0Y5a2z1bVIrl
         7XvHZwsysH8zyvDVPRAntFLncDMSdBbL8YVwT+7U7zuHiMRn9+xjGtBSPbOvw5ygGaQ7
         ap1Q==
X-Forwarded-Encrypted: i=1; AFNElJ8axM8oF9Q4Dg2tNwHl0GsZeLobZ6xIT8+wKmQRrmtnwIgCtW/1kpdGl/18gdH/SXYVo2siP3o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzoBF0A2VlvZj/Ir8hHyXYuECD6vL0KP/zQno6S9SVwKY3GIuss
	/mHMbuTYqonnEPqkdw8O956ibyvHEw9qnSdiWq1AQ8nDzM84250obgKw+Xez+aYpUiytdSCJMgk
	IHeB3OCes/hHaKykqhzM1+g==
X-Received: from pgbcs4.prod.google.com ([2002:a05:6a02:4184:b0:c79:8b14:e151])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:580f:b0:35f:bae8:3531 with SMTP id 98e67ed59e1d1-3657761ae72mr698785a91.25.1777936249486;
 Mon, 04 May 2026 16:10:49 -0700 (PDT)
Date: Mon,  4 May 2026 23:10:47 +0000
In-Reply-To: <20260504224213.1049426-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504224213.1049426-2-jthoughton@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504231048.1184273-1-jthoughton@google.com>
Subject: Re: [PATCH 1/5] KVM: arm64: Grab KVM MMU write lock in kvm_arch_flush_shadow_all()
From: James Houghton <jthoughton@google.com>
To: jthoughton@google.com
Cc: chenhuacai@kernel.org, gshan@redhat.com, jhogan@kernel.org, 
	joey.gouly@arm.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mips@vger.kernel.org, loongarch@lists.linux.dev, maobibo@loongson.cn, 
	maz@kernel.org, oupton@kernel.org, pbonzini@redhat.com, ricarkol@google.com, 
	seanjc@google.com, shahuang@redhat.com, stable@vger.kernel.org, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, zhaotianrui@loongson.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 4, 2026 at 3:42=E2=80=AFPM James Houghton <jthoughton@google.co=
m> wrote:
>
> kvm_arch_flush_shadow_all() may sometimes be called on the same `kvm`
> concurrently in the event that the KVM's `mm` is __mmput() at the
> same time that last reference to the KVM is being dropped.
>
> T1              T2
> KVM_CREATE_VM
>                 Get VM file from T1
> close VM
> exit_mm()       close VM
>
> T1: exit_mm() -> kvm_mmu_notifier_release() -> kvm_flush_shadow_all(),
>     with only the KVM srcu read lock held.
>
> T2: kvm_vm_release() ---> mmu_notifier_unregister() ->
>     kvm_mmu_notifier_release() -> kvm_flush_shadow_all(),
>     again, with only the KVM srcu read lock held.
>
> This leads to a potential double-free of
> kvm->arch.kvm_mmu_free_memory_cache and now with NV
> kvm->arch.nested_mmus.
>
> Cc: stable@vger.kernel.org
> Fixes: e7bf7a490c68 ("KVM: arm64: Split huge pages when dirty logging is =
enabled")
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  arch/arm64/include/asm/kvm_mmu.h |  1 +
>  arch/arm64/kvm/mmu.c             | 23 +++++++++++++++++++----
>  arch/arm64/kvm/nested.c          |  4 +++-
>  3 files changed, 23 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kv=
m_mmu.h
> index 01e9c72d6aa7..30d5c24fcebb 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -178,6 +178,7 @@ void stage2_unmap_vm(struct kvm *kvm);
>  int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigne=
d long type);
>  void kvm_uninit_stage2_mmu(struct kvm *kvm);
>  void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
> +void kvm_free_stage2_pgd_locked(struct kvm_s2_mmu *mmu);
>  int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                           phys_addr_t pa, unsigned long size, bool writab=
le);
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d089c107d9b7..4bab407d43bb 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1021,7 +1021,9 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm=
_s2_mmu *mmu, unsigned long t
>
>  void kvm_uninit_stage2_mmu(struct kvm *kvm)
>  {
> -       kvm_free_stage2_pgd(&kvm->arch.mmu);
> +       lockdep_assert_held_write(&kvm->mmu_lock);

*facepalm*.... this doesn't account for the other callers of
kvm_uninit_stage2_mmu(). They will get lockdep warnings.

I've attached a diff to the bottom of this reply that *does* deal with them=
.
:( Sorry.

I'm guessing Marc or Oliver will probably want this patch to look quite
different, so I'll wait to hear from them before actually sending a v2.

In the meantime, I'll properly retest with lockdep enabled.

> +
> +       kvm_free_stage2_pgd_locked(&kvm->arch.mmu);
>         kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
>  }
>
> @@ -1095,12 +1097,14 @@ void stage2_unmap_vm(struct kvm *kvm)
>         srcu_read_unlock(&kvm->srcu, idx);
>  }
>
> -void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> +static void __kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu, bool locked)
>  {
>         struct kvm *kvm =3D kvm_s2_mmu_to_kvm(mmu);
>         struct kvm_pgtable *pgt =3D NULL;
>
> -       write_lock(&kvm->mmu_lock);
> +       if (!locked)
> +               write_lock(&kvm->mmu_lock);
> +
>         pgt =3D mmu->pgt;
>         if (pgt) {
>                 mmu->pgd_phys =3D 0;
> @@ -1111,7 +1115,8 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>         if (kvm_is_nested_s2_mmu(kvm, mmu))
>                 kvm_init_nested_s2_mmu(mmu);
>
> -       write_unlock(&kvm->mmu_lock);
> +       if (!locked)
> +               write_unlock(&kvm->mmu_lock);
>
>         if (pgt) {
>                 kvm_stage2_destroy(pgt);
> @@ -1119,6 +1124,16 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>         }
>  }
>
> +void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
> +{
> +       __kvm_free_stage2_pgd(mmu, false);
> +}
> +
> +void kvm_free_stage2_pgd_locked(struct kvm_s2_mmu *mmu)
> +{
> +       __kvm_free_stage2_pgd(mmu, true);
> +}
> +
>  static void hyp_mc_free_fn(void *addr, void *mc)
>  {
>         struct kvm_hyp_memcache *memcache =3D mc;
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 883b6c1008fb..977598bff5e6 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -1190,11 +1190,13 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
>         int i;
>
> +       guard(write_lock)(&kvm->mmu_lock);
> +
>         for (i =3D 0; i < kvm->arch.nested_mmus_size; i++) {
>                 struct kvm_s2_mmu *mmu =3D &kvm->arch.nested_mmus[i];
>
>                 if (!WARN_ON(atomic_read(&mmu->refcnt)))
> -                       kvm_free_stage2_pgd(mmu);
> +                       kvm_free_stage2_pgd_locked(mmu);
>         }
>         kvfree(kvm->arch.nested_mmus);
>         kvm->arch.nested_mmus =3D NULL;
> --
> 2.54.0.545.g6539524ca2-goog

And here is the diff that should fix this patch. (Sorry!!)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_=
mmu.h
index 30d5c24fcebb..e32e844943be 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -177,6 +177,7 @@ void kvm_stage2_wp_range(struct kvm_s2_mmu *mmu, phys_a=
ddr_t addr, phys_addr_t e
 void stage2_unmap_vm(struct kvm *kvm);
 int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned =
long type);
 void kvm_uninit_stage2_mmu(struct kvm *kvm);
+void kvm_uninit_stage2_mmu_locked(struct kvm *kvm);
 void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
 void kvm_free_stage2_pgd_locked(struct kvm_s2_mmu *mmu);
 int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4bab407d43bb..98ba8116676c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1019,14 +1019,6 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_=
s2_mmu *mmu, unsigned long t
 	return err;
 }
=20
-void kvm_uninit_stage2_mmu(struct kvm *kvm)
-{
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	kvm_free_stage2_pgd_locked(&kvm->arch.mmu);
-	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
-}
-
 static void stage2_unmap_memslot(struct kvm *kvm,
 				 struct kvm_memory_slot *memslot)
 {
@@ -1134,6 +1126,24 @@ void kvm_free_stage2_pgd_locked(struct kvm_s2_mmu *m=
mu)
 	__kvm_free_stage2_pgd(mmu, true);
 }
=20
+static void __kvm_uninit_stage2_mmu(struct kvm *kvm, bool locked)
+{
+	__kvm_free_stage2_pgd(&kvm->arch.mmu, locked);
+	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
+}
+
+void kvm_uninit_stage2_mmu(struct kvm *kvm)
+{
+	__kvm_uninit_stage2_mmu(kvm, false);
+}
+
+void kvm_uninit_stage2_mmu_locked(struct kvm *kvm)
+{
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	__kvm_uninit_stage2_mmu(kvm, true);
+}
+
 static void hyp_mc_free_fn(void *addr, void *mc)
 {
 	struct kvm_hyp_memcache *memcache =3D mc;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 977598bff5e6..f61f0244f0fb 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1201,7 +1201,7 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 	kvfree(kvm->arch.nested_mmus);
 	kvm->arch.nested_mmus =3D NULL;
 	kvm->arch.nested_mmus_size =3D 0;
-	kvm_uninit_stage2_mmu(kvm);
+	kvm_uninit_stage2_mmu_locked(kvm);
 }
=20
 /*
