Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804502D7810
	for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 09:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572050; cv=none; b=QkSE+DfuU4wl6dpXPvTatmG6Q50OgUnXrW5yQ3AzsUjNCM2gkseZYSEwmmwoACGsUn8g6eDouF7ZWYwHnrauZioTBnJRb7P/5u0n26YtNXsGfr6iVznpE1DWqnuZwDkkSHJ8i3yt8pn81PoRC8qUYl6d741bx6eTpzREpQm009Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572050; c=relaxed/simple;
	bh=aLq6w6iMVx9A+GXdrTT+UqPhvEMW4mi+b5uKE2VvZds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DkKsBWV5eg/oGUzUN+bp9NtKkUOMQ9VWCJzHFGYH7lkz1VZA7SX62COYjg1//5zqsO7vJZIElBgfjlJAcVIef6oKKN0c2p0vwJbLr/9w1TJBZn74V0UgkSpJLItJyhHkQk4bsYzhJR1aXvikkyqpPK3JKP2XP41w3B9cPIeZkgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FPfxKXMp; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FPfxKXMp"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-456267c79deso2667035e9.1
        for <kvmarm@lists.linux.dev>; Tue, 15 Jul 2025 02:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752572047; x=1753176847; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=FPfxKXMpT7woFzhIf+tZGtpSPcAQGLGX5hceuPGFXYxchczrvUHe5EfnjoGfd42cuT
         2AqTUGSIo14JCHrfsapnOOrHbJgk6jc9UwI28b/Pu1aiEz7jKct0rfXxJqQ07mNA7B7g
         X6najF4YK0Kd+vdh+L8lY11iUUfRoa8zNnduDvWpgEi6Si2I0P+PwiAm+EdwgP0tBjlw
         Fy5rZwTOT7hlk6OPwyPV/Gf25oitJ4pwjc+uOdbZCGC4Fetn4eOYZTMvkP0K3+UIFwBP
         /zR+JWQdGcxX7RlO1MoFwjCIuZF5VXO1TQumKGRNPc+OoOwsGZPW6KgGNmc7w0rjP3sy
         qyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752572047; x=1753176847;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TkuKuazKKizZ6ZlT9w9fSwNujhSChJOs2f7h5A8NbUM=;
        b=oVeWeRoZbxQ71HBMNqVbf0MvCKQq6zazNGj7ly8skh/LqBcuLwQgKXp3J8KhEEF/2L
         NjTY61QQBQzzNyZ0/cLz6XP/PETmZIdbPWL6uWONrl6fuSBmlY6y6obvGqbjZUgr+Ed2
         brbRiJyS5RTJmZYUBWy5/QsuWWvKgXSpoXxbeJre3hC8/xP0Y4hgCeGYIcTJ9J3V5kka
         gA2zUez34+oTY5vPBluC/1s6ZVCN5bmNG0DSDS+t1bas9WBuVYTcmtA7XtoVuHH8NlFH
         oCkgac7fNd9LmDtOwREd0sijlcUwuHkTKmBDvqryGnnf2i/9+aCxz6Ryy1+0kRYaOpU6
         D1zw==
X-Forwarded-Encrypted: i=1; AJvYcCVxSSBwHAPWtrxoXOMh2DNh0RJoHRJueAuA15U3UEiw48ohKL4nXIxmQgFwqrCwQW7jWdW9jVA=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywzm7oYcnlCot0PSHcjLz4nmMDUSOCM8KMTTV/J5nLiWOO2Gd8E
	hzzEP/CFaRvS06YmJ3MTzKLQFhyvp84ZhuCVVd8y+ZmWMyHl/WMjqyUCVC2OE6E12VoQORvWJ0Z
	1jw==
X-Google-Smtp-Source: AGHT+IGHXP0t1xMDlthuKsBdUUCbcrAxXrLxIuWqHsf1c70IZpuqDuBfFbcmN2MndgHaJWicrlcB1Kwa1w==
X-Received: from wmsn28.prod.google.com ([2002:a05:600c:3b9c:b0:456:2003:32a5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b0b:b0:456:1e5a:8880
 with SMTP id 5b1f17b1804b1-4561e5a9020mr52008185e9.13.1752572046722; Tue, 15
 Jul 2025 02:34:06 -0700 (PDT)
Date: Tue, 15 Jul 2025 10:33:36 +0100
In-Reply-To: <20250715093350.2584932-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250715093350.2584932-8-tabba@google.com>
Subject: [PATCH v14 07/21] KVM: Fix comment that refers to kvm uapi header path
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The comment that points to the path where the user-visible memslot flags
are refers to an outdated path and has a typo.

Update the comment to refer to the correct path.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9c654dfb6dce..1ec71648824c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -52,7 +52,7 @@
 /*
  * The bit 16 ~ bit 31 of kvm_userspace_memory_region::flags are internally
  * used in kvm, other bits are visible for userspace which are defined in
- * include/linux/kvm_h.
+ * include/uapi/linux/kvm.h.
  */
 #define KVM_MEMSLOT_INVALID	(1UL << 16)
 
-- 
2.50.0.727.gbf7dc18ff4-goog

