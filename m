Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57D948FF8C
	for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816382; cv=none; b=mxpBqHebgBIVTegob+F78Q4a4vrTMcwPAy0OtBiUmZGz7rdTII2Iu5ITGJm8PQggVUieBeFC5gNBh9IVhGnctvotyQWSTMwjEippit9pb1pPBSI4vW55i5CD0bPZICZQvwL0ox7DwBsytRSMpS+ZRVPcJtoJ5NgCQ8l2ymIL8bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816382; c=relaxed/simple;
	bh=YarLj6Tl5drs4d48GxIIPRySQhK4PE3lDvu4dKT16oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KXipcuWCkCaSkw5If4ARCg05r/F96b9g1ofA4uoMiFGB8lQM5iwnf1SOLTg1oxWZYegGh2RqmsWRdb/A4jbCfzdtzvI89kVaEwNNeq0bTrBB6rdGH+C/eEp10SkiTbFr9xwlB+FOzqHE6LE20Jcu1PtnVkYYM9ppO6tNJjfxtxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Koe0XBFu; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Koe0XBFu"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5338f65913dso22437141cf.2
        for <kvmarm@lists.linux.dev>; Mon, 12 Oct 2026 07:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1791816379; x=1792421179; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kVDh4BcUbgvIW1O8+CoyCzwwqxHQNia8D9+ovujPztQ=;
        b=Koe0XBFugwB5l8xdnaR4iZv4wTI4cg3pQ2StDaPs0vyL82G48BDGD3OzsELhmRGUFQ
         mKPP6IScUodzY+JmBXGzin/PizbUAcfOqttN1I9IwQKnRwP9mL2Jqhf1Z3KIiGXGKcZ5
         B1IXrzGtg/lodfsia3iOykn/4AZQ1oakWWIRXVBNfPVca9t9JaKRhep38Q17hvX2CQIT
         U41TMqRr10mOSWHh4+RyLgB/hlZy47qxQQcx7Z/UDqo9M+Qcq0sbmJsgd4GPC8TM12Eg
         vR05uDq94fS4uNsoVypUArB1cn8h/XD+Qn6KNedmM9uhG8VIrGGktIf3SlYlnOL4Wix3
         E4Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816379; x=1792421179;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kVDh4BcUbgvIW1O8+CoyCzwwqxHQNia8D9+ovujPztQ=;
        b=Af4BTO9Uvu2VGE7qCr6pCunGrTYf64gZOCmUOBBeA0bSw/AVaWmfVu52cJOQA4mFS4
         TwD4lJfYC/Pa22rM6gGwb8HbQMNtOOlxHk0gGEGOo54xphGMBzxs2RYfrAYe+t1AL0eF
         +WND16mOgyVnCv/Heml4iX/TDbn5Om5LTEty8wSjPDeY1AkLr68Denp0KwY8ky2l0Htq
         w+0XtzWK8uXZepNaar8KQzQD6arB2Dqv7r9p9mAKiHqWLK25OEAQCIMaNttnNYFRIWAx
         b0dhMmsr8ay9LYiNah6wtZJNt70fbZjP4n8JprLQKRD17OwOoLWGpiX4GtZu8+uhCjDu
         HbIA==
X-Forwarded-Encrypted: i=1; AKwUvByd9s6YkVVIoFHI+xd+Kq1Vtf7tRe9MPxD+sFwAkEoG0ZY2HbQoKznF4w/D/y4R9lLachQgeiM=@lists.linux.dev
X-Gm-Message-State: AFq9FYJoT7cDiiyMlZwDyzWyq0W90x2Jpe/T9wzMET99GEj9FnsRLn87
	/xg3X4121KZyTU/YJIIHh7Ux6EMMB38Qarnmg63acawBQC/c0cgpHaiKFiJ85QqCppk=
X-Gm-Gg: AYBFou229vqRvDo/bzBQBxQzfn53XaASio9i9cIgy4C71oBh5cS+4p2Ebh4DpUZw53Z
	TuzkkA56RUNNKxtnDYPW52vd4qjCmAPpKiHhXNNK+sgL6gNH3vc3e1ZumxcXP/8yGNDcPyrw5cY
	7vGNWf5a/lERAxDrFHown77IpJxAX+c2Q/fwSiMVczW+6Tlzp7NV7+HxMzbbfJNvfympKqGjO7c
	RZwN67H4JZM+90Et5jJMDOUUCInmISGy7QiUN8f9q7LIWDi2uUP4gLAHITtDOyaHvla4J1XU5kW
	7J4BehlIrteYklOyHYZh6OBA1coKBCEylgdBs5rQ7c22wHLs9iinv+howyrBdzyb4a5Dop9xgc8
	EeoviaujyIUPlKVha7pfXFhsG5kO+n7x79NDd0nJz9ui8jvBDNKtGpD6aKAgUDvCIETc9ekyndL
	jdMzrPtULEDikY9kP8w/nUrY4amVwUkWdv9L8pAHEQKHVyCPPz7xhpHGCkXD+5QVV8V9wovlPCE
	fw6WXLog5CKTH7BSS9TylGa+oWzMzqtoEMN03U8Cf6je0lixiXpKuQl
X-Received: by 2002:a05:622a:2487:b0:535:1134:91b with SMTP id d75a77b69052e-5359faead4bmr160454661cf.14.1791816378499;
        Mon, 12 Oct 2026 07:46:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-535e652f3c7sm3157041cf.26.2026.10.12.07.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:46:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xGHI8-00000006SW2-2nlk;
	Mon, 12 Oct 2026 11:46:16 -0300
Date: Mon, 12 Oct 2026 11:46:16 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Fred Griffoul <griffoul@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kselftest@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	x86@kernel.org
Subject: Re: [RFC PATCH 2/6] dma-buf: Add get_phys() to describe a physical
 run
Message-ID: <20261012144616.GF14213@ziepe.ca>
References: <a04f17cc-f59a-4240-81c8-29776eee3a2e@amd.com>
 <20261005132046.30025-1-griffoul@gmail.com>
 <f0077cec-10fe-400a-b229-f7434e297364@amd.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f0077cec-10fe-400a-b229-f7434e297364@amd.com>

On Mon, Oct 05, 2026 at 04:53:34PM +0200, Christian König wrote:
> > KVM gets its frames through the KVM-private guest_memfd provider
> > interface from David's series. iommufd gets them through a private
> > interface with the exporter, as it already does for vfio-pci. The new
> > version adds a small registry in iommufd for that, which replaces the
> > symbol_get() of the sample in David's series. The dma-buf is then only
> > the handle and the existing revoke.
> 
> Yeah that approach sounds totally sane to me.
> 
> We have drivers which stuff all kind of resources, not just memory,
> into a DMA-buf. That ranges from MMIO BARs to trigger FW operations
> (doorbells) over full HW blocks (ordered appends, global wave sync
> etc...) where two or more applications need to share which one is
> used.
> 
> That you then have a exporter private interface is for accessing
> this is perfectly ok.
> 
> The problem you are facing here is more that this is not limited to
> one driver/module but multiple ones and you don't want module inter
> dependencies because of the symbols.
> 
> So symbol_get() is probably the right thing to do as long as we
> don't have something like weak symbols or similar.

I don't want to keep expanding this hack in iommufd. If dmabuf is to
be used then dmabuf needs to provide a pluggable way to fill the
iommu_domain that many exporters can plug into. I don't want to
hardwire every exporter into iommufd, that makes no sense.

The existing arrangement is to motivate solving this problem
generically, not something to be expanded on.

Jason
