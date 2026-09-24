Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C104E8E12
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 21:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790286793; cv=none; b=RLVi3gPurHrMKme7BJuG2jO9WIEgyCxnUmcJPrnl0QKig66jVmRIGyMxLXLtWGxSQSYsPg1jfuP3Ykre2HZ+UdRK7d2s9EQJQWS9SNEUwOCDZ/FRSAARR0RF5nSMWaMhFgEP8qBE9pdVrT4uop+GtMvSSlQsnduU+j/lDNTrdSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790286793; c=relaxed/simple;
	bh=RbSuvXpZGJzj7DyvR5wUr6ym4Nnq30Ym0ZQqCgZv2e4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NIG0JE/j7GIflKzHQoQjigZaVjKHqne+MlaFTP6Ts4W9OQmiS+J2rLdCmUTx6nMxiCvDhg+9V6TxO1xADTgr3PTwPGyrxcaWgd7eYLo3QgihE3xAx3PRjQcusmBEA7B19JdwZpB9q2g9dDy9eTDvLpHHgEbDtbRUOLKGFR1BAJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DBqRGMSG; arc=none smtp.client-ip=209.85.216.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DBqRGMSG"
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39b77130a7fso268413a91.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 14:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790286791; x=1790891591; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6LkhgjIPo4LQGHd0bFnsw+pSTli362MQLpClW50HsSw=;
        b=DBqRGMSG9dWDD7std5XL7Uw3SRonlKSPkKPntzNJ0Y0fYgo+ENdj11VJCXNncWacfU
         YGsn0QaWq//kpjhTnDlKXxqPZCARVWLs4AJB0Muld7qM/xOZgAjzDPquFdmpgZR4niA4
         Z+jbo/YsIFiJhYQ8KwK1UVPm9Cd6S6O+muaFt4BEgPEvFTSJGDyeJaEEuC0ZTli/OzEI
         I+n1ABNHZGktzlgFbOjB/gXPjZWkTTX/WvdVEtOohuwqliYPdlulNx4LY7V/l7TuYkHh
         nHBdM/m68fpZpN98TjoxaZAZjDYCieiQJgqOpY4onIl/H2V8xm5m9wKZD68z1q30c8zi
         TN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790286791; x=1790891591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6LkhgjIPo4LQGHd0bFnsw+pSTli362MQLpClW50HsSw=;
        b=in4Xs3vFNbiuWB5oRtaV6aIjsO5tJIF4PtP/MsYdnoY+ibX/TX/sJlR4sxjsPSdsiV
         KP1Y20ahmL6qKkIFsKDqQrifC19RwjKBfpap4HBjB5AiSyq0HrgJPyNCcRlOdv2hR3DR
         hSdB80tXnxnjLq7Bc1nAHXyQ+eBGz2U2Tq9Gb0K0IYp4RXsEaThL7F0l1olciQPmwtE1
         o5wu5SdQlQ1p5QqRoXBKIp8YmUpvldiv+kA2MGEZWPQe1bAonEXDNbc2Fl1otzQZR9z0
         8EeL3O/EQ0vavTEbqMoUpUZweTmKroHqLy+a2bOMcEsnu23lQn+fIvkIkYq0Odfx+tRW
         u/Kw==
X-Forwarded-Encrypted: i=1; AKwUvBwZDU2ee0KVI8YbVKOwSvR9z3aE0HX1tiQorp9717HEuc6EhMVxXFLXsHUZRNYKq7Jz/6oT9Oo=@lists.linux.dev
X-Gm-Message-State: AFuF++nftCrVRApsIxMeZyzvD6lwUFRAxHumdY6H5Cdt+3tG5y9xc/jW
	XdMyHu+8uBRD4qRDxTZxgkJUTNuw+i0nqHbJ+dnG8P2vS83MF4wfJJN35ARCjKDbVjr2wQO8cJS
	ED+RhOA==
X-Received: from pjrv22.prod.google.com ([2002:a17:90a:bb96:b0:3a0:9658:1de6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2703:b0:3a0:2ffd:1a4b
 with SMTP id 98e67ed59e1d1-3a098ce5269mr3354853a91.25.1790286791218; Thu, 24
 Sep 2026 14:53:11 -0700 (PDT)
Date: Thu, 24 Sep 2026 14:51:51 -0700
In-Reply-To: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <179028368772.2007408.8775233545709825615.b4-ty@b4>
Subject: Re: [PATCH v4 0/5] Stop returning struct page from guest_memfd PFN lookup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"

On Wed, 26 Aug 2026 09:01:45 +0000, Ackerley Tng wrote:
> v4 splits out a new patch (3) that makes use of KVM MMU invalidation logic
> introduced into the RMP fault handling in patch 2 to avoid warning on a
> benign case.
> 
> Other changes in v4:
> 
> + Took Sean's version of the changelog for patch 2
> + Picked up Fuad's Reviewed-by: and Tested-by:
> 
> [...]

Applied to kvm-x86 coco, thanks!

[1/5] KVM: SEV: Treat unassigned RMP entry as benign race on PSMASH failure
      https://github.com/kvm-x86/linux/commit/211606532680
[2/5] KVM: SEV: Drop page refcount early during RMP fault handling
      https://github.com/kvm-x86/linux/commit/375b32931b5d
[3/5] KVM: SEV: Check for invalidation before warning on unassigned RMP entry
      https://github.com/kvm-x86/linux/commit/acafcf32c83e
[4/5] KVM: SEV: Drop page refcount early in VMSA reload
      https://github.com/kvm-x86/linux/commit/3c427e5c0347
[5/5] KVM: guest_memfd: Stop returning struct page from PFN lookup
      https://github.com/kvm-x86/linux/commit/89fbe3de01cc

--
https://github.com/kvm-x86/linux/tree/next
