Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECE31C07C3
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 16:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753981081; cv=none; b=MS6pld68bVAsBhxOa5aCOyJ8veST2JFWHrTsbnbqojYxcX9IMrMLqenjhV4GG2H0t0I47oqnpwezp4ZJCRoCBzMQ8wB2FYHN67Xtrh4VfxnzQzm5B5QuDRNDlT3/R4p/moH/SMmZgNo2A5yIFO7Zt9Eadz9MBtazigERoJJVBDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753981081; c=relaxed/simple;
	bh=sYmx/wQQxsT0OJ4i5ILgxPjIEHTJZkdf4b3yA/YfuDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C7iSEE2LvGRTBW30ca7/IVC+d9YNKNGTjwfY6jnCIhNrdTf3MaDL7xCQTwK1prRwv1J/yICjfuIk5u/iL4GzrmbSoQBN8Xwiyx9vRE+cT1cqsu5I8edQmAZ+aPlWG3TcVqozt6i2c6Lhnmbve3XgAlqHbuI4KiYQjTe4LkdsTMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=RV4U+Mvo; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="RV4U+Mvo"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7e2c920058fso232919485a.0
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 09:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753981079; x=1754585879; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jr6COAzZQd1YZD6Knd07jyj5Q1nEe5SAc40WyTUG0tI=;
        b=RV4U+MvozBkDYNBlDzOoMbaJPDeoxurBMYDBwsBSR7MhocKevD7c+YkVQx0bwCHLYr
         cJckTdJeGnD+r28W2/jP5i3PTMHD50BCGzYl9l+caQwCfygk6W1727zlq8K4Zfq0gec0
         bpPWJ3CwXndkvHZ9I3oZsifXBxPbWPHBKnZprOdaFaMhN+Tyvq0kpCASckqMYK4XXD5H
         l/808pUo2AsDPFxCqSWvoAMAJ/1m2CgxibYjfk9NP3WuZxkvr91pETHqD11IsriGOt3X
         jLw/Ig050VMo/AfRhcw8Gh3LtB0EXBtoa8AmmobjzQbzj3EzKi/HqpPLGRoO8JNB7sXq
         nQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753981079; x=1754585879;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jr6COAzZQd1YZD6Knd07jyj5Q1nEe5SAc40WyTUG0tI=;
        b=QCX6+ozUvQWkO/G7PePrZnD118m5UTBDSAWRzOSrcjCgjfY0aASIl3lu2NtKnzcsdn
         dbzrdGhQ0q4fqNyvU/Mit/uDrw0XnPfrSugY4NZOHhsQnCFU3hMHylSnMxP+oX1EV4Dn
         VOpN/meM7JUgI/jcAXVqpEX6HKWsF2W3fe7qnYVn5FOE0lNkUgVBG9PtFL623IBCWGpQ
         KBZIOEBCd4OQZSfeQyaDAOTEMQsfrEO7udiopdDMB8SyOWTP7ZfFMaMPwcdQFkAVl+HX
         Db7c0GC32OQ0ILkmMMN3jL+ntqaSZA/TpODdMc1GQT8STlPGkV6VfSvEb934Io/VTpTF
         rWzg==
X-Forwarded-Encrypted: i=1; AJvYcCXo3jtbObvbf4r+fxJJzbhtsMf6UPiilCAY/L4mrfQMSP5lyiuZf2x18kFfMPUcdSfYh/0Qk/8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwobQfjrgFAqZFBiFTqxVhQfnVecb0QQKbXVZkoAVq9SBSy8avU
	51qzQV4666kw0U9LPfMAO82bGEzRtpKXfIPp8WCkT0qL1H6w9e+X+i5hu4asXtZvf1I=
X-Gm-Gg: ASbGnctDhT2DxpjUTSE44iDB0XlgsVWDgg4UciD7RD0UjCW1yUpJh7Z5Kg5l/SIcGfm
	/M+9dwpazYTz+mb09QDqR460BFEPIz7x+vFHBNjW6WYzAEP0RIcJlvonFeXceX3G+2a16kraryu
	fdvejZOsDCrxfc3ceeO37L8jqoDLDS4x80QiQukmSvVII1W8LhZFLU85suCKBcDNr6xqFXoxuh1
	hmqNA+Q6L1Hn/f7I1jBch8HFGl5uCr7S/IZ+9MAmWzwtW5iVFPGpOLWylJTTODCnHCY6VYRbAjK
	gG6OS2qOpGHk+TB9BstCpBb4XkeTQFghtFkmwuDTZFcdBOkMatKS9pi9v3hI6eXiXbNDeecH6bK
	Ya7F7pVDjNtIa/orWh+TzBYywqd2sfoqiEvxtzHTELdlSQucYkH5em/9ps4ckHbB/lAr2
X-Google-Smtp-Source: AGHT+IF0HcZH8FVBmKJ4GmjA2mzyAVblpZ7PRNdTI+fWx8fAyi9WQRlG7UaDpDQUTKMH5yyVV73AIA==
X-Received: by 2002:a05:620a:4515:b0:7e0:a51a:b393 with SMTP id af79cd13be357-7e68128ccb4mr331058485a.7.1753981078536;
        Thu, 31 Jul 2025 09:57:58 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f706406sm105256385a.49.2025.07.31.09.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 09:57:57 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhWbN-00000000qFA-1y2m;
	Thu, 31 Jul 2025 13:57:57 -0300
Date: Thu, 31 Jul 2025 13:57:57 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <20250731165757.GZ26511@ziepe.ca>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-30-smostafa@google.com>
 <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
 <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aIt67bOzp6XS_yO-@google.com>

On Thu, Jul 31, 2025 at 02:17:17PM +0000, Mostafa Saleh wrote:
> On Wed, Jul 30, 2025 at 01:47:52PM -0300, Jason Gunthorpe wrote:
> > On Wed, Jul 30, 2025 at 03:07:14PM +0000, Mostafa Saleh wrote:
> > > On Wed, Jul 30, 2025 at 11:42:53AM -0300, Jason Gunthorpe wrote:
> > > > On Mon, Jul 28, 2025 at 05:53:16PM +0000, Mostafa Saleh wrote:
> > > > > Register the SMMUv3 through IOMMU ops, that only support identity
> > > > > domains. This allows the driver to know which device are currently used
> > > > > to properly enable/disable then.
> > > > > 
> > > > > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > > > > ---
> > > > >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 92 ++++++++++++++++++-
> > > > >  1 file changed, 91 insertions(+), 1 deletion(-)
> > > > 
> > > > Can you split the new iommu subysstem driver out please? I think I
> > > > asked this before.
> > > 
> > > Sorry, maybe I misunderstood, do you mean split this patch into multiple
> > > patches or split all KVM SMMUv3 driver out of this series?
> > 
> > Yes the latter, the iommu driver introduction is best as its own
> > series
> 
> I thought about that but I was worried the maintainers wouldn't like
> introducing the infrastructure first in the hypervisor without a user.
> I am open to split this, but let’s see what they think.

You can merge both series at the same time

> Makes sense, from the kernel point of view it will be attached to
> identity/blocking domains, but the hypervisor api is just enable/disable HVC
> as it doesn’t know what is a domain. If terminology is really a problem,
> I can make it one hypercall as “set_state” with on/off or identity/blocking

I would call it set_state with states IDENTITY/BLOCKING. That is
clear. enable/disable is ambiguous.

> TBH, I am not sure what hardware does that. So, another option is to fail
> gracefully if RMR exists (which falls back to the current driver) and then
> pKVM would run with DMA isolation, which is the status quo.

iGPUs either access the DRAM through the iommu or they use some OS
invisible side band channel.

The ones that use the iommu have this quirk.

> They are not random, as part of this series the SMMUv3 driver is split
> where some of the code goes to “arm-smmu-v3-common.c” which is used by
> both drivers, this reduces a lot of duplication.

I find it very confusing.

It made sense to factor some of the code out so that pKVM can have
it's own smmv3 HW driver, sure.

But I don't understand why a paravirtualized iommu driver for pKVM has
any relation to smmuv3. Shouldn't it just be calling some hypercalls
to set IDENTITY/BLOCKING?

> I am not sure if we need get_resv_regions, maybe it's useful for sysfs
> "/sys/kernel/iommu_groups/reserved_regions"? I will double check.

It is important to get this info from the FW..

Jason
