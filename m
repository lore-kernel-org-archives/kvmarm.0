Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2A230E847
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 11:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778499961; cv=none; b=TT9RiAn9vB98TxTlMJy7FdWttfN3+dzadFjPL7U/lAg91hftvQahMyarcgqqA1y6w8NWp0oZu7VtsgPOYxjSQNg8l1kU2EF7jVsJ3t/YnbPswtAzYi5D2aL353ZnXxAju/HueQfk4DxFGs+1WfS6bSiWTMLNXg7kLz1sAcS4mXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778499961; c=relaxed/simple;
	bh=VpRWbnLBmOW52eWfeba/JJdhQXbjyJk0Idet3KASW58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VBUaGDTs0mfz6mKBid6efyAmLpyB1ya/7LgYSfXsMk1EOSZsG/ElAl99KftFAeFaELcK64xq+fFmBqqVXdch9Z0DXdCdoG80yEO3hnQjHD3N8NHvuPka6PELXaOqdJ12Vcqo3/m63N36Lmgj1r7zoVKs98P0mB2DJrRJkXov9L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aHn28dyh; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aHn28dyh"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4891ca4ce02so835e9.1
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 04:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778499956; x=1779104756; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QffmlXKfGIQMvoSpoqBH5tpd14K+nt5m82a+AK1qlTw=;
        b=aHn28dyhFVxnq6bRrWpSZ3AtJd8fSFjLTB1+3QSv+Exm/Aat41rhJWjiIz/CwnPY/U
         o5p8Lcm2J0i7mdSRODyaljYEzHpO57+sVtnk47+cL7H37QvFYosyp46i2WDpkeh6erhw
         wVM/MpxvSWJnxiYmc5QWFXT77EhxmR3UuKz02Mu0SVHkjvcNMlQF62Sqd7D2SURdlKuN
         RdpfDmO6mzl0F7SQ4MwCegzvxVM717QCvDhPr3KAjAAh0vc47lD0pNM6ESP566xH+/aR
         b61243QgoMil9fUwI0Vq4XEFAFBSi9MDBuQfYp3Ui1UazLivoX/yKAxLGB3prHgg0dFE
         tIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778499956; x=1779104756;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QffmlXKfGIQMvoSpoqBH5tpd14K+nt5m82a+AK1qlTw=;
        b=AyvAqwmVnW/ydmsFsJHWSEewBeOGjCZanLyShB5R7EYweflEFj/b1poN5oZCBKEwl9
         1HRgYrMv91R0OkR7KUY+V3DAL+0Qw/9y9MDbUDxHFE0JM0KycLZ/bqx5P7tp3Kb+EHWX
         hns/DMbxDvUlz2IsRz1LQLn4+wQak0Lc9ZHBKep+mRqKbWySY9xkdiOODPjt75hC2466
         HGuCMo3enRgn71yOF72wYE/fNicWtrXUeJvtOfNJsL9hvyhp3Xi0Y2+ZdtMwW5igJCnY
         TjNy7vAWyLXej64vlLxV96GztKQFN6G7JNFiN3Jo8ywnffKmCTHsrlQJgnRRdSIYenUL
         tatw==
X-Forwarded-Encrypted: i=1; AFNElJ8Sq2oIin8NLZsDl9hlE+De/JkeiluPFmaI1r62qBNNRglPBMx8IMs9p80u5T9vtMinABHsIA4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZPrscMlF54uUK5gNaIOMzmLpX0AAyTdUdi4Wn8Faez2FiXoNf
	F3n15xj7I7L4IQA0CFBQffepDe/mCuP7xACFlekttPsc3zde46qrdfV4ObHJWu3kyQ==
X-Gm-Gg: Acq92OFq1avVKs61qVB4HNu+BSGY3Dkotrn+Q+swBssk6OFmivxIk1apDGmcWtAPUpB
	L5p/XUkVrgoCM/efuFK4fHEvCD6ETNH+EarOyJ6IVDcEybDRYD5Mlgq8MMSzg8wFkgMGV4kS+3X
	5659gQLnur7V/xFt+uS8kGSz8nt1L5lEGQvAxvW13HM7PPT8O6vroTLI6wmgRrwu4aYjD/jqOCM
	yH0C8bYUNEWZ7u3yUX/8smgVvPPS2vAei4I2OHJegsNNZmuXWc1AZgV+t54QwGdmTxmghIeb/bb
	a1Wsieuz48NRWsDUI/qxLK4lTl7uC8Fi/sJgzqHWV5wBn+pSVlK0PHega9dwfr/bpCSuHo3HMSB
	5fODgnLd0Dt4eTyZMcgOmP4NecQMhi8vdPRRoIEoqxyhdBH5MbhZgq9AOlXb1MBodfeLfqc+KBQ
	omUtVyPn4OXwv6RezcfwwcsGj+qWDEY9sd5laQ59MJyVKKYwp03reVfKYdFSQoFApMG+o=
X-Received: by 2002:a05:600c:348f:b0:48a:5618:b4d4 with SMTP id 5b1f17b1804b1-48e6f4f6da0mr2636305e9.1.1778499955998;
        Mon, 11 May 2026 04:45:55 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454917d57aesm25552833f8f.26.2026.05.11.04.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:45:55 -0700 (PDT)
Date: Mon, 11 May 2026 11:45:51 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <agHBby1qBvR6cmJY@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
 <afiN1UwS9q6F6A_v@google.com>
 <afoYBYIJOTClsdLS@ziepe.ca>
 <afoeIVIGE-JjYy22@google.com>
 <afsPfEzgGtAFrN5P@ziepe.ca>
 <afxd8Km40A5ulZvd@google.com>
 <20260509232931.GJ9285@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260509232931.GJ9285@ziepe.ca>

On Sat, May 09, 2026 at 08:29:31PM -0300, Jason Gunthorpe wrote:
> On Thu, May 07, 2026 at 09:40:00AM +0000, Mostafa Saleh wrote:
> > But that doesn’t solve the problem, which is: At some point, whether
> > eagerly from the page table code, through gather sync or a fancy
> > invalidation array, the driver will need to populate a range
> > invalidation command (tg, ttl, scale...) and this logic is better
> > shared with the main driver which is this patch does.
> 
> My point is this patch doesn't share enough. If you do need to issue
> invalidations then share everything below the top level tlbi entry
> point and don't try to make a pkvm version of the entire logic just by
> ripping out the range logic.
> 
> There is no reason for pkvm to need a different algorithm
> here. Especially when you get to supporting ATS and multiple devices
> and smmus you may as well just use the whole thing.
> 
> Which is why I suggested to copy the entire call chain into a shared
> file

Agh, actually this seires doesn't deal with ATS, which I think is
wrong, propably we have to issue CMDQ_OP_ATC_INV for the whole
space on every S2 invalidation which has to be done per-SID and
as it can't be done by VMID :/ or just hide ATS support from host for
now, I will look into more for v7.

But anyway, we don’t have to share any logic, the kernel driver
is quite complicated as it is designed for a different use-case.
Doing that makes the hypervisor unnecessary complicated and
oversharing this logic makes the kernel driver less maintainable IMO.

The hypervisor only needs to share the architecture spec of
populating commands.

If that’s a problem. I am happy to re-write the RIL part in the
hypervisor. It's not that complicated, but I thought it makes sense
to share as it is a HW contract.
Otherwise, we can break this part into some macros that are called
by this function and the hypervisor but that's maybe over-engineered.

Thanks,
Mostafa



> 
> Jason
