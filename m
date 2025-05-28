Received: from mail-ua1-f73.google.com (mail-ua1-f73.google.com [209.85.222.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2029A212FAD
	for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 20:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748463483; cv=none; b=p8VIQOp0RL8gUIKvU8kXFHo941BR9nzL2EumdpW5DVE/+ff7Ws2V7m2oka+AvyyaVaqHnwh7zOq5OF4te8Did3NfHzwQO63UQhIrxivfY0kHwdSLbZrsMxKpdFrx/oSjt8i5qAHvs74EwQFvSJZrBtbXRnTMxrAbjWwIHgOPRLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748463483; c=relaxed/simple;
	bh=MW9va8ZpX3dYh3E3JLHuTSkrOEon9HLdeDcTvo+YAEU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rPLbNMMGwRjLEN4rzco3rdlPUkWVXLrPvW5X+9/iEPJpD5Ji3e1yMTuI62HpR2tgzanJzl8i/b6IMEU/scngntim/jbsrG2s1bKT0LRdbenVIAuHsdURvWGHR1sxLKhQF1i1/9bmDr0NlK/ov9iDb9R6buM2DFbOOPCe4Ka3DFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HyRbqIXg; arc=none smtp.client-ip=209.85.222.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HyRbqIXg"
Received: by mail-ua1-f73.google.com with SMTP id a1e0cc1a2514c-87dfd711142so35555241.0
        for <kvmarm@lists.linux.dev>; Wed, 28 May 2025 13:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748463479; x=1749068279; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pS3L3KRfz5KN2f4PHSrDwEqqU16vREHLyymMNsMjI1o=;
        b=HyRbqIXgMZjW2EF/PifJRZF5skaWPUsVl/9vkUzO+oXqAxFjURc3GWfrWdWDcYhAld
         F3mD2sCyA7IBK6IDoH3Nos574JWzRW6PbyTdGdW2mFLdHyv8F+3wrc5IWY1zdlwXtb/b
         3e0PlWgVd3gapWmzfdbrZDbTGvvSzbTiVELuVA4KigBR1PHS6vPcYNejEIJIpvNwm5I3
         Uk5/4/PLMRjTm2JuWzRmkpmawnnQsOw6Mie+8t+zwmLOsb5KWITKBiAOuq4ES9ddsgaB
         38M+ubqGdmI2CsUJaPhpxOjoK/usaFxDcdCEVVraU1ZhjgKUveznM+pmT0XLj5hppiWZ
         lthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748463479; x=1749068279;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pS3L3KRfz5KN2f4PHSrDwEqqU16vREHLyymMNsMjI1o=;
        b=uRONkj9zxttRdO6CpQozYidoZ/1YyDw2E9fpF75eSxA6klIbx/hHBQZphtODL9wmu/
         6iAdKUckaNCQ780KAMg96aCD9fPiEZ4nlkIv1oSmPzmlW/DNE4c9rbB2o7yISXyX1j6x
         8bSjuSh0K1hS0VzJFM5l7fD2mI7vdX6G6BgRvHMQGI6UsTe/Sd5RHDXScNMbSYwHWWU+
         y9Tn4HhnZ/0pmv/zm2sVQfU2FcNyFvpEM2n5zLc+l+Qknb2ooz64yX4AlQk9QMBDzESi
         ntFXHVJ1MwYZ7fmNdM4JA1RRNBjNCloSsXsS5diRaFWUzQlhrViWRcHUjmNLTTiMEJvl
         XD+w==
X-Forwarded-Encrypted: i=1; AJvYcCVc2eXUGUEg15THLDj9ly+c1qOSDRdcHycNew/bVC4vXjnG+BRefLBS+UziyL+fJc555Ovt5eM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxA+kIrq1O9sFtEP56mwhSoBczRr7+qzGbr+BilNPjRw+MHR+8f
	kaZmkQfmxj0oKQqOoNGM5jQzaVuJey0isfpmpqQGVsOspAre+7V4dZvSvPKG9XLlu6etaJyd+xG
	Gg2KXVlRhcC/q3vXzgpOPyw==
X-Google-Smtp-Source: AGHT+IGyUJTOXQyn/15OsOvKdvYlJU2g7lRit6+I+UryLZeKjuoksIAEOAqNG3KzRBgJ4D83T1qgfTqVSbHb27/G
X-Received: from vsve42.prod.google.com ([2002:a05:6102:faa:b0:4dd:b083:d38c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6102:5092:b0:4e5:ac99:e466 with SMTP id ada2fe7eead31-4e5ac99f42fmr1294267137.18.1748463478924;
 Wed, 28 May 2025 13:17:58 -0700 (PDT)
Date: Wed, 28 May 2025 20:17:54 +0000
In-Reply-To: <aDdILHOu9g-m5hSm@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <aDdILHOu9g-m5hSm@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250528201756.36271-1-jthoughton@google.com>
Subject: Re: [PATCH v2 06/13] KVM: arm64: Add support for KVM_MEM_USERFAULT
From: James Houghton <jthoughton@google.com>
To: seanjc@google.com
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 1:30=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> On Wed, May 28, 2025, James Houghton wrote:
> > On Wed, May 28, 2025 at 11:09=E2=80=AFAM James Houghton <jthoughton@goo=
gle.com> wrote:
> > > On Tue, May 6, 2025 at 8:06=E2=80=AFPM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > > @@ -2127,14 +2131,19 @@ void kvm_arch_commit_memory_region(struct k=
vm *kvm,
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0const struct kvm=
_memory_slot *new,
> > > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0enum kvm_mr_chan=
ge change)
> > > > =C2=A0{
> > > > - =C2=A0 =C2=A0 =C2=A0 bool log_dirty_pages =3D new && new->flags &=
 KVM_MEM_LOG_DIRTY_PAGES;
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 old_flags =3D old ? old->flags : 0;
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 new_flags =3D new ? new->flags : 0;
> > > > +
> > > > + =C2=A0 =C2=A0 =C2=A0 /* Nothing to do if not toggling dirty loggi=
ng. */
> > > > + =C2=A0 =C2=A0 =C2=A0 if (!((old_flags ^ new_flags) & KVM_MEM_LOG_=
DIRTY_PAGES))
> > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;
> > >
> > > This is my bug, not yours, but I think this condition must also check
> > > that `change =3D=3D KVM_MR_FLAGS_ONLY` for it to be correct. This, fo=
r
> > > example, will break the case where we are deleting a memslot that
> > > still has KVM_MEM_LOG_DIRTY_PAGES enabled. Will fix in the next
> > > version.
> >
> > Ah it wouldn't break that example, as `new` would be NULL. But I think
> > it would break the case where we are moving a memslot that keeps
> > `KVM_MEM_LOG_DIRTY_PAGES`.
>
> Can you elaborate? =C2=A0Maybe with the full snippet of the final code th=
at's broken.
> I'm not entirely following what's path you're referring to.

This is even more broken than I realized.

I mean that this diff should be applied on top of your patch:

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5e2ccde66f43c..f1db3f7742b28 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2134,8 +2134,12 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 	u32 old_flags =3D old ? old->flags : 0;
 	u32 new_flags =3D new ? new->flags : 0;
=20
-	/* Nothing to do if not toggling dirty logging. */
-	if (!((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+	/*
+	 * If only changing flags, nothing to do if not toggling
+	 * dirty logging.
+	 */
+	if (change =3D=3D KVM_MR_FLAGS_ONLY &&
+	    !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
 		return;
=20
 	/*

So the final commit looks like:

commit 3c4b57b25b1123629c5f2b64065d51ecdadb6771
Author: James Houghton <jthoughton@google.com>
Date:   Tue May 6 15:38:31 2025 -0700

    KVM: arm64: Add support for KVM userfault exits
   =20
    <to be written by James>
   =20
    Signed-off-by: James Houghton <jthoughton@google.com>
    Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c5d21bcfa3ed4..f1db3f7742b28 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2127,15 +2131,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *new,
 				   enum kvm_mr_change change)
 {
-	bool log_dirty_pages =3D new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
+	u32 old_flags =3D old ? old->flags : 0;
+	u32 new_flags =3D new ? new->flags : 0;
+
+	/*
+	 * If only changing flags, nothing to do if not toggling
+	 * dirty logging.
+	 */
+	if (change =3D=3D KVM_MR_FLAGS_ONLY &&
+	    !((old_flags ^ new_flags) & KVM_MEM_LOG_DIRTY_PAGES))
+		return;
=20
 	/*
 	 * At this point memslot has been committed and there is an
 	 * allocated dirty_bitmap[], dirty pages will be tracked while the
 	 * memory slot is write protected.
 	 */
-	if (log_dirty_pages) {
-
+	if (new_flags & KVM_MEM_LOG_DIRTY_PAGES) {
 		if (change =3D=3D KVM_MR_DELETE)
 			return;
=20

So we need to bail out early if we are enabling KVM_MEM_USERFAULT but
KVM_MEM_LOG_DIRTY_PAGES is already enabled, otherwise we'll be
write-protecting a bunch of PTEs that we don't need or want to WP.

When *disabling* KVM_MEM_USERFAULT, we definitely don't want to WP
things, as we aren't going to get the unmap afterwards anyway.

So the check we started with handles this:
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 old_flags =3D old ? old->flags : 0;
> > > > + =C2=A0 =C2=A0 =C2=A0 u32 new_flags =3D new ? new->flags : 0;
> > > > +
> > > > + =C2=A0 =C2=A0 =C2=A0 /* Nothing to do if not toggling dirty loggi=
ng. */
> > > > + =C2=A0 =C2=A0 =C2=A0 if (!((old_flags ^ new_flags) & KVM_MEM_LOG_=
DIRTY_PAGES))
> > > > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return;

So why also check for `change =3D=3D KVM_MR_FLAGS_ONLY` as well? Everything=
 I just
said doesn't really apply when the memslot is being created, moved, or
destroyed. Otherwise, consider the case where we never enable dirty logging=
:

 - Memslot deletion would be totally broken; we'll see that
   KVM_MEM_LOG_DIRTY_PAGES is not getting toggled and then bail out, skippi=
ng
   some freeing.

 - Memslot creation would be broken in a similar way; we'll skip a bunch of
   setup work.

 - For memslot moving, the only case that we could possibly be leaving
   KVM_MEM_LOG_DIRTY_PAGES set without the change being KVM_MR_FLAGS_ONLY,
   I think we still need to do the split and WP stuff.
