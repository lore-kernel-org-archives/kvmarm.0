Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F3321128D
	for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 21:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753909885; cv=none; b=Jsn0hgFAMzLUsvHswrEEfMh1w/PVaxENnuJNrLtAH6Bk7JZPlwWpQY3BD/io84vDhoy80F0+HOslHS5L1/XoEmf254hjg/+oAjnoMp/2n9q5Je85SupxU2YLbyEHbfIh+Zv3i25mv9iOOKJl7Xfcq1T7jEQXbPdec9QxFmjCmTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753909885; c=relaxed/simple;
	bh=cVmFzsj3OpZTUi6FUzCWejRWJRm0o5ncvOdXgEoC+OE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ReUV5EJVsiVDcTKFfNKqjL9w5OzcRaZnoegzyGmWzA4HAQyNkhTFFtqN/3HI79HbrsfBNd+Et9BJ9Nqxzd5rz3tGjb9gKwayMhwQlOFMU87NLb6RHeJH/cj79LS9PaudgoF9pCrm2h5svAcEygtKPMEUQNPZrPt8AEhME8+ABGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YXYXWmjm; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YXYXWmjm"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-748f3613e6aso142762b3a.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Jul 2025 14:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753909882; x=1754514682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zcr0HAZVJL/wPM68//kB0QFOkcy4cqNgVvPP1uhkVrY=;
        b=YXYXWmjmxRYkgwSs6q9F/UONr44dXv90ub39oTFHNWMOMbmT5ddd/HgF4FAq6+jxnt
         7NdmMV9LkyNQmOs0/Q4z3sjnPcxgqR+LCSLtF8mOe31E4Um9EtEkX5Urr6Rp+OE+6kvv
         FZ8MYX3xWYHKAQVlDBTbspnN+IpfrQ61vLtLWvjkTc3RkIeSY0F94AxxJFVi+Isvg/Pl
         enhsGIQT2VcuG7eiiwK7CH+6PPp6FxC2UFEJwF4uRsp6kXsfoMPC/rqkYHLPBcBEf3M5
         KI+Z70yKPhpMrU2aLSJuDeYi/vKSA2R747dC2Pd+VDR3MCgWyRyjloobnFwlunOyNY5v
         p1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753909882; x=1754514682;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zcr0HAZVJL/wPM68//kB0QFOkcy4cqNgVvPP1uhkVrY=;
        b=wuLQQnQe4euIXrfKwAPslsowKMzFrpA0MrStfHqCqEnkPspmIIHy9nW3yMd38tbt2N
         5hgE/Wpl9yD/LdcyQI4JFV/XiOdGyLncZ6g009+GWHL2aro6UWqIdS+GteluZ2Abki5J
         IRv8WWE/KnTegsXIIqgt8Aa7cDKmAts6rtafV4Du39A4u6RuKOZAjtxM/cty4Og14ZxS
         M4mr8KyGJJs7Rwb6bQAvUvIFTZSvqVN2fPSVoTsR1Z9BVZgLgFb5WBC6dIhSi1yGhpgy
         darLIlMJN07aZD97V450+x9azb7xv05tbVCfgHYlfal1eGNFzAUQZj4fwHXkFyMEQHNk
         Z5Ww==
X-Forwarded-Encrypted: i=1; AJvYcCV4oamQuxtJN/rL1viVZe+Ju9mbRXhXL7tqrWNZLOpD3RVTNI5yDOG/IekCWJZW/zMTjDrheRg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLxaxcER2OTN24l40h6CGf5zDCBWxFTFiqHtV+qWpKIFExQ7Pg
	tGAK+oTUjME3OC6VGx1mdWrXsBExTPHAr/dWO3E6Ot26OqhCsdJm9zKEqy2G958v2YaZDo3Tef4
	2HtULBHsb/EFh5EZ44u+o/A==
X-Google-Smtp-Source: AGHT+IH81SELHZh+GPX7YKucdrOrQjsD2qC5Y2tfTvaMHB5OVH1Y4cxqU+ojrj5t1POmR4E8onsMP+EV8Hr7rDZV
X-Received: from pgmb10.prod.google.com ([2002:a63:1b4a:0:b0:b3b:d2a0:df40])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:12d3:b0:234:216b:cf98 with SMTP id adf61e73a8af0-23dc0e8609fmr7392654637.35.1753909881916;
 Wed, 30 Jul 2025 14:11:21 -0700 (PDT)
Date: Wed, 30 Jul 2025 21:11:18 +0000
In-Reply-To: <20250618042424.330664-6-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250618042424.330664-6-jthoughton@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250730211120.4163536-1-jthoughton@google.com>
Subject: Re: [PATCH v3 05/15] KVM: x86: Add support for KVM userfault exits
From: James Houghton <jthoughton@google.com>
To: jthoughton@google.com
Cc: amoorthy@google.com, corbet@lwn.net, dmatlack@google.com, 
	kalyazin@amazon.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	pbonzini@redhat.com, peterx@redhat.com, pgonda@google.com, seanjc@google.com, 
	wei.w.wang@intel.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 9:24=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Only a few changes are needed to support KVM userfault exits on x86:
>
> 1. Adjust kvm_mmu_hugepage_adjust() to force pages to be mapped at 4K
> =C2=A0 =C2=A0while KVM_MEM_USERFAULT is enabled.
> 2. Return -EFAULT when kvm_do_userfault() when it reports that the page
> =C2=A0 =C2=A0is userfault. (Upon failure to read from the bitmap,
> =C2=A0 =C2=A0kvm_do_userfault() will return true without setting up a mem=
ory fault
> =C2=A0 =C2=A0exit, so we'll return a bare -EFAULT).
>
> For hugepage recovery, the behavior when disabling KVM_MEM_USERFAULT
> should match the behavior when disabling KVM_MEM_LOG_DIRTY_PAGES; make
> changes to kvm_mmu_slot_apply_flags() to recover hugepages when
> KVM_MEM_USERFAULT is disabled.
>
> Signed-off-by: James Houghton <jthoughton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

This patch fails to remove the WARN in recover_huge_pages_range(). The
diff below will be applied to the next version of this patch, whenever it
comes.

This WARN can be hit by enabling KVM_MEM_LOG_DIRTY_PAGES and
KVM_MEM_USERFAULT, then disabling KVM_MEM_USERFAULT.

I've been having offline discussions with Sean about this series; I'm
waiting for him to rework the KVM_GENERIC_PAGE_FAULT bits. I'll dedicate
some more time to the QEMU side of things too.

Thanks.

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1f..2d83ddb233a9a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1779,7 +1779,7 @@ static void recover_huge_pages_range(struct kvm *kvm,
 	u64 huge_spte;
 	int r;
=20
-	if (WARN_ON_ONCE(kvm_slot_dirty_track_enabled(slot)))
+	if (kvm_slot_dirty_track_enabled(slot))
 		return;
=20
 	rcu_read_lock();
