Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E552F691B
	for <kvmarm@lists.linux.dev>; Tue,  4 Nov 2025 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762279050; cv=none; b=n8Z3SJF9IatlV6rxnNUKsrCx31303ppuhI2qeGah8VqMscO6I9rQ7b8cHSxmrYleNBR5M/4QS5npm4ShJIV8IPUK3aNnLtfyeNCTt3945n98k1cD88KR4mayONarZS2txvCkOYb8xptAMxVbcSMhB+FE+rH69fN0l6ZsOerY7BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762279050; c=relaxed/simple;
	bh=EKtg11I2y89dxK71syiNOTNg3HE8V+Mj31tEd40SOxE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uiPhxV0OAICrVBpNL+wRJfDoDO/sWiLUs5ehAioyMF9DLlqIOH2SK93GDiGeE7VdWi7VuBZbQXNOpAXo2JuAGerFLxQjg3Z9ZzyllSiMyPJiVQGiBX5t2g+3eKwTUPCn1r/rz+HVjxCDQEmE3sTWooQ9Fr916hxHMD/w9lN834c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HPiqO0G0; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HPiqO0G0"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b9d73d57328so2152898a12.1
        for <kvmarm@lists.linux.dev>; Tue, 04 Nov 2025 09:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762279048; x=1762883848; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kxFvD6gKxB44i1bxk1sbjy38espILrC0yFM/UcBrpew=;
        b=HPiqO0G0CclvjWePPkqamwPsUnzl+mcpYndGD+XKIGT/g2Sq20JwIfEAKkJVcoGhOo
         YHODfjj7Tob7296nrz3GE6vazURwFYTMKl9gSP/9sQEEPZgi8F5A9dCCiGV8YsV3M3P6
         y6WfuL6uRrm85yrl4j8YVJh4b9czEnN44lWdhN4FfT7TfuEEP9p13GZLYgUrJ8JkYSSv
         wSZYdv47B4xDhx+HbM6UNiangXo4PAB7xut8dzZ4BmU6Dtbx3N6S5SAxUGcmo6JZrsSW
         5M240r4t+LMMUKWG0SkkndfcMcI/8NLvd0oOSgPwF6WApR5q/yFYuqkD1nhuELTWfXx/
         nFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762279048; x=1762883848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kxFvD6gKxB44i1bxk1sbjy38espILrC0yFM/UcBrpew=;
        b=WAO09akgIh/innWaJcf1zgFyOSWh4SS2UKWyKImShSt2i0rlDbUMgVHlFHI2jwhABC
         wnQ0mdxjuUtq7cAadSD4FQPezbGgNk9plg6seRey7oQePqBZe8EfYSOcNbvhxUlZf/SE
         5L/8bCtm/z/1uvftmR2C44D31Tjchpspcv+ePdo5beHCeZyXssmFZYfnERBcVp7ACr+/
         0IJRizIMiHcTVqjNbQ17GDFCsTOHL4YjVtYkY76nKz/kX1PJ+/svOEY2O/rCxvJAdB8i
         a+OgnWPDYil3uX05Uep+BIEax2RLqD1/poZ1mfRh8ioql5DYOMI63QzRUsyVhB/PeYgM
         ecFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNCenHK5S5zBjOH39KbUSku8V+D+OJUeX2hNrLI3cKvPw7BIT7eQ7qUeHPXhRZs3CX0psMEBs=@lists.linux.dev
X-Gm-Message-State: AOJu0YxF2OrXZ06Pl5dzeeG+EC0aDB5isHOjnhQSiDgrpQomEoubsh8M
	VE9KrLVB9G39lbc9cx3Dnx18i4HSZMmfy18GAnvZ+sM5KXXXoscEvSjMY7OPH9OeR6SWNKyfm61
	x0v6FxQ==
X-Google-Smtp-Source: AGHT+IFJG/V0EfaymcoM6cPfayQ+DGikxVc9kN5RoO6CmqYed2gXkivkS54tuPy9BQi+XScmFB78yDVh2jQ=
X-Received: from plblv11.prod.google.com ([2002:a17:903:2a8b:b0:290:28e2:ce5d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ffcf:b0:295:2c8e:8e56
 with SMTP id d9443c01a7336-2962ae715edmr5562415ad.44.1762279047867; Tue, 04
 Nov 2025 09:57:27 -0800 (PST)
Date: Tue, 4 Nov 2025 09:57:26 -0800
In-Reply-To: <aQMi/n9DVyeaWsVH@yzhao56-desk.sh.intel.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com> <20251017003244.186495-5-seanjc@google.com>
 <aPhjYcOFjL1Z8m2s@yzhao56-desk.sh.intel.com> <aQMi/n9DVyeaWsVH@yzhao56-desk.sh.intel.com>
Message-ID: <aQo-hus99rE7WBgb@google.com>
Subject: Re: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
From: Sean Christopherson <seanjc@google.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	x86@kernel.org, linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 30, 2025, Yan Zhao wrote:
> On Wed, Oct 22, 2025 at 12:53:53PM +0800, Yan Zhao wrote:
> > On Thu, Oct 16, 2025 at 05:32:22PM -0700, Sean Christopherson wrote:
> > > Link: https://lore.kernel.org/all/20250709232103.zwmufocd3l7sqk7y@amd.com
> > 
> > Hi Sean,                                                                         
> > 
> > Will you post [1] to fix the AB-BA deadlock issue for huge page in-place
> > conversion as well?

If you (or anyone) has the bandwidth, please pick it up.  I won't have cycles to
look at that for many weeks (potentially not even this calendar year).
