Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBA23AB5D2
	for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778589403; cv=none; b=tcIU0WXCuM/VUATf80k4gvb6QILLuj+VnV122UtidOvr+6q5N7CUb8Yu0a+dqJXcBLwXCt8aJbbrI589hd+bTKU/lh91gDBps7ZpuMoOp5wcXT7e1+mfTSRUxrDGbKEnaCTZuhqgbbeWw4vIU+WJBmdpjOZdRsv1UVyK8V21FLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778589403; c=relaxed/simple;
	bh=QuXcvbNKcdRmJ0PUN7xsL0HY9nWmc8jMrwxpJx0KWZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J20REJPwILaIDFglj6wnBaC6EDHs6CgJAXbTohhdStVMvAmaKl6S/LQmwOf6ivmOyGxaMH9/GUylvhjJV1pg1w/hrIHb5UQBPHfED5N5g5terWk1YnWmmr7hO9PoXgqANjPKzGxFL+iPaOnwpbQNhBePMEoanncnonwCn1rxDyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=K3ARYiQH; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="K3ARYiQH"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-514ae601df2so13042421cf.0
        for <kvmarm@lists.linux.dev>; Tue, 12 May 2026 05:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778589393; x=1779194193; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MOp4VzQJzpVrzaLWG2n8IsNxEYbCwRvMjRwLio3IkjI=;
        b=K3ARYiQHob2GOLdEyCUnOsy8g+2jZe4IscAufQkYYjy1YpN+ln32DwhIFKsiSwt2DJ
         gCdoMcKe5lDoTlUDrbsXo+U5wqJWsMx1t7GCvGKcp4B7oIBBUFLPuXASWGoH8oVSm0wf
         WxRGOiZFNqIArjOMq3JzDp5CvGTNXJD/aFdK0I6BvJU/hriKzDz1f185NqH2vbgJ+1+k
         6V56tijB72BSgtymbmpo3fNraXKrBRqtQhTeHFJfr6ka3kR+j7H6DAngmDHaVeIYcMHw
         csmChOba2OwWSt1mQlObVMsGXUYZbfiBkZmbNrt+ty10DIiLjuPNZpEARziwbo5fMFRB
         394g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778589393; x=1779194193;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MOp4VzQJzpVrzaLWG2n8IsNxEYbCwRvMjRwLio3IkjI=;
        b=oF+zl5G7RRx1PLgyUlECR0tNBEDXAZRyeJWvXoA4YF444k/IqNQv7wQehp3kiwjjly
         dWYUnSHGT8Vl14J54pHHdKG2T/Ovg3pDHGjJdNZZt5Yemh7WQ3ER0WFaJ6KOQKKQ1b7K
         kBaJ1zFwv6CbdCZik6VqWCxM1NjL+d8LY8IWy5jHl6XCDjn9snZz3i8AO6OBNz72nFmv
         UQ876wEZcDdXamvs7EYP8C/uqVSjRYd8rztJLi6bVu2hOWlKr0uV9/9Yjq2gQaF/ywUh
         y7sQvekJU7iLL5xUD71zi3NEfkcq53UHfXj3N6RSfTggDCPnBj1SXSjfYo9sUc727QrN
         25dA==
X-Forwarded-Encrypted: i=1; AFNElJ8rLtFQz+1jDOvQ2G9l/L3cskIe2WDBvN6rom+BLtGe6TdXSFia8WF+lXyAylpriTJ19qXwTU4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyiJFygknrCAgg3Qy1jDdLt3uLVo3wCkgj/s9TzO2Lj7khv+IGa
	n/eaiOZnnA9IFAVnYMM+8vDF6Otn9cIXtbdaKoI6YYhidjXBicWxH9B0UYUNJp8wI9k=
X-Gm-Gg: Acq92OFRn8ic/pK9/Yz+fwuW3MBvzm78jbVneukdkgi+Uy6guhMcZZm9/MSODABdo/F
	KcOD4loJC3mzF643hNQRIA/03efITU5x5NhVwqtFHp4JP7g5UiMMnWnOuXRj9DDP7t+kdez5ZhF
	MvWFN0e08ILP/MHQ+TdybcBe6amEaZPe3GmtLdTGSiGlwwL/HENlz+fldMaRF0Xi+AWmfaH6/tb
	hYUo2hkaKamSHzsLSle0BZW0wuzvQZpgzyNl9s0UOSuF8gj/CGbYFS5pUqQ09DUXe7P5xOmOcHf
	r/MryT9L0tJUU0sx8yKsxMuml1yfzq2d83ANp7H6UQhyh0L6X5ltmEsWDrvdLJV2NBEjlDZPYAy
	Zya3JkMtKkJx2TG4nx0skD7NDb1TCv2bkcvh4GRy6sfuqaCuQkkWgWBdkdRZKDeUM8O/L9cREhA
	hYjUOPe1rkN2bzHMJ2KVQ/Barz2LdaWID4FpYoxOrZx3nFzxfuTyJ9cyhMQVsHJc8TMdoesoALQ
	59Ryw==
X-Received: by 2002:a05:622a:4ccc:b0:50d:97e8:939b with SMTP id d75a77b69052e-51461f9e47fmr406246311cf.36.1778589393437;
        Tue, 12 May 2026 05:36:33 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53cd827c5sm391412326d6.40.2026.05.12.05.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 05:36:32 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wMmLg-00000005AiQ-0kgs;
	Tue, 12 May 2026 09:36:32 -0300
Date: Tue, 12 May 2026 09:36:32 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <20260512123632.GT9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-9-smostafa@google.com>
 <20260501130006.GF6912@ziepe.ca>
 <afiRB3e3o0G1oZvY@google.com>
 <20260509232714.GI9285@ziepe.ca>
 <agG8XtrHUfWGy-kd@google.com>
 <20260511142232.GP9285@ziepe.ca>
 <agMEFhxsmjpO0thM@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agMEFhxsmjpO0thM@google.com>

On Tue, May 12, 2026 at 10:42:30AM +0000, Mostafa Saleh wrote:
> > Also io-pgtable arm cannot trigger BBM behaviors, so how do you
> > implement it?
> 
> At the moment, we workaround this by mapping all the memory with PTE
> level, while MMIO remains at block level as they never change ownership
> at the moment.
> 
> This is one of the missing features I plan to add after this series,
> if you look in the cover letter, these are listed under “Future work”

Hrm, I would not be happy to see io-pgtable modified to have bbm
features :\ They are very complex this is what iommupt is for..

> > So that's the real explanation, KVM cannot manage the S2 in the right
> > way so you can't share it. RMM/etc are managing the S2 without
> > pointless page faults so they can share it.
> 
> Well, there is not really a right way, even with a fully populated
> stage-2 page table, you can’t guarantee not getting TLB conflict aborts
> without FEAT_BBML3 (which is quite recent), unless you map everything
> with a leaf level, which then impacts performance.

I mean, there is a right way - you need to rely on the BBM features in
all HW and fully populate the S2 for no faults. So if that isn't
present then you are doing things that will harm performance to work
around the issue. It's fine, but just explain in the commit message.

Jason
