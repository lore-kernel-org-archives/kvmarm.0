Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42281D95A3
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 19:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787082948; cv=none; b=hxb2EElTAFrsPeqKHpEo7yWGuJzgzNrItbgCgv/mZb3Y+lwSqPe1kF1x2A0DjYCQvcktvXHJ6mM+1vvjN3RHS8/ofV+FZR5x9Ic/TBaOqMSJlUTZjcV+qG+ajXAcqHcFlK/qubY6fxo4esSHU7q47/AdxQ+e82p8yGEJWznGjSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787082948; c=relaxed/simple;
	bh=iCso+0ky8Dzh3YExOIjLuI1F1ucg1k8ItKeGzglIZmA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UtjBYaviK2rOtsSXB3UEUn2kP2mOmetAAxAwfqGzcdNRQQ9IMQv/Zq0dbHlMJZTa6jetj9DA4nT8T5LIwzRLXv5wZEeFCXkvsrOHhaYiMK+L0W5MMC/Oki4q3aMlYcBtR1y1YPTSGoz5eW5Upw6Lv6J4Y+IMzbziPDnhDfzmm8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=R1TZVxBo; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R1TZVxBo"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cab3e9cd922so104679a12.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 12:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787082946; x=1787687746; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kuUJP/9WbIJ+dwbEGRfTcEg4pKKbPnOHED5niMcUDBA=;
        b=R1TZVxBo/WoYtSKGNYBzkbN3pvoTQXNplKj4boaGX8SUOZE0NfP46pCk6p+XEvDbNn
         r5K4nohiqRbeYoMY1E+G9zGkg7biRw9+nb4/ddYm5yqvOLAYoiX+KAGwnHApZeydgj78
         VstuFCiD7gWM3YLk5kAyhlu67rbWbRfx/2jB+WAMKJG1Y7P0vsfmUbDXqNy4DwppBgiI
         fHl/l6nTTaBLTFmOW7rsFHCBU4JUVs2XpkJqXuwiOyPkEiSECJcsh/jDHENQtGZz8zkA
         ybrGfD4udSkEK99vCAmT9AaDhJ/AcKVhj/prGm08lOUSqe/JuRTV9IM8v+Ino/Ygf/Ee
         Alug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787082946; x=1787687746;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kuUJP/9WbIJ+dwbEGRfTcEg4pKKbPnOHED5niMcUDBA=;
        b=ma2C08iiYK70Le2WI0EH/0w5NoQZP2JOaQyVhPK2j+JR/sGe6AUSGUVwD49uffPwXG
         uDQ2iY/SJoNWgan6dqPro3jEHCHsD6jqsWUsQyp2J0NUUO4CRDyNWPfkw2J6gpcUPxIs
         iDDroRBk0dwUTAgYL6R1/exlMztTWsMXs9iOu7Jd/Q5L9lYD0kYjq1EItI4NjG6C/scJ
         h+KD5oGAHwyaUtPub7yAwmFP9QXvxDnsqyckeUFUNMbcH/U7DykyB95kis4StqDcsvLM
         oP4HsmOtL7Aw2+yoFQi65Y8QHfAv93PdAzC+yRIlPiSPQ99+d+6cvmvGrQ7MvRR5LwaR
         xclQ==
X-Forwarded-Encrypted: i=1; AHgh+RpZwjodSKKrBSrhDV+NDGwv/jUqVrL6CTgHsRESsoBhY/qieLCNJsbqTS9LUMWS5PoMFU0zCe8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5TVTugSrlmKCaHTET7JH1Bt0sJ9cIhoWJgZS4RzmSDZpGJHYF
	PIEj1lqUAPQUJnrdQJ0Er+QkpwcE+nzMXner2iktRenE87q0CLziQxp/73C8gsByyvPUGIlkMrv
	gaBQdrg==
X-Received: from pglg36.prod.google.com ([2002:a63:1124:0:b0:cc1:522f:464c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:cd96:b0:3bf:6d96:ac40
 with SMTP id adf61e73a8af0-3ccfef7af73mr418448637.12.1787082945745; Tue, 18
 Aug 2026 12:55:45 -0700 (PDT)
Date: Tue, 18 Aug 2026 12:55:45 -0700
In-Reply-To: <807b4b9f-b1ca-4b5c-bc9e-22bf0637ba33@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com> <807b4b9f-b1ca-4b5c-bc9e-22bf0637ba33@kernel.org>
Message-ID: <aoS4wd6Dy9DlluHl@google.com>
Subject: Re: [PATCH v2 0/4] Stop returning struct page from guest_memfd PFN lookup
From: Sean Christopherson <seanjc@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="us-ascii"

On Tue, Aug 18, 2026, David Hildenbrand (Arm) wrote:
> On 8/18/26 11:15, Ackerley Tng wrote:
> > KVM currently expects kvm_gmem_get_pfn() to return a refcounted struct
> > page. Callers (such as x86 TDP MMU, arm64 Stage-2 fault handler, and SEV-SNP
> > VMSA / RMP handlers) hold this refcount across page fault handling.
> > 
> > Holding a page refcount across fault handling is problematic for guest_memfd.
> > In-place memory conversions between confidential computing shared and private
> > states inspect folio refcounts to ensure exclusive ownership by guest_memfd.  A
> > concurrent guest page fault taking a reference on the folio causes conversions
> > to fail due to an elevated refcount.
> 
> Right. Won't we still, at least temporarily, grab a reference while looking up
> the folio in the page cache, or will we be preventing that concurrent race with
> locking?

The latter.  What I want to aim for is that if the relevant guest_memfd range
has never been mmap()'d and there are no memory failures, then conversion is
guaranteed to not fail due to elevated refcounts.

Or to put it a different way, I want KVM's ABI to be that pausing vCPU is *NOT*
required to perform an in-place conversion.
