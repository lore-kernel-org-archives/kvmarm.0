Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793026929;
	b=rgXyPUqxqUiK0yZT/PGfKXonRSMwNW2BwPgkR+rOvMEdnfCHdJENMe7FbWaUEYilMA0t
	 gKYKq5WTXW1jIZrFXGAF0LzKCHnlDIax1TDZJgIeZgiARzVXKM6eRAhGCgCBV3WJUspNN
	 NQmvgNbUWV+7l9nTADJ4PiMoWAGfpW0DhOQX4ZEiyR8G0SlqTLCO7Cr077Apys7IiQMmp
	 asewLjY+DFnTNiZt+KzYqcteaeVxTGTh9PkgVNdEthbaCSD7+q66m25ZpUIfQL9Tsv24m
	 PKGA9u2ZIgSYJK4nZb19oSGPhD/E7VSCGWP4GYexVJ/whb4BBa7PHhOT7yvl4L0gFtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793026929;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=m9xXitEiI+hi1F9clvRlUMjS8JnuPFDTdYXDE0kyjzc=;
	b=DckbaP+2s9/KKk8PVYY4VH+9/Xm0PPlvhV3BH04b3Gwb7KsC+Cysxz1FQWNw9O3iU7Js
	 XMVEx3Msv/9uyXGmMHDov2ccoFT4UjpyQkd/d9ayRGbjN+CohV659Yp5sMA55UiA3CBBj
	 +gn7vd6T3X/e2Sdu5D7u828RgquTpaWpGaFqBXLQQqca8moBwl9KhrhEGizKJiAyicGNa
	 nolQmn+Hi11jfJFDgVlMWJ33ROC7M80go0Qxi7J1s6yy6e2qWLvL+eWUyBL25C13+UCJj
	 ExxqAqD3QLzYHCyh3PIT5zNYxhwhWoXTcD/9rTVXPX0HcbKkXo1Kd/eo/oDWolBFvxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Fq8fBUGG;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7691A606A31E
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 15:02:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7691A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Fq8fBUGG
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AEA1B1655;
	Mon, 26 Oct 2026 08:02:03 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EA793F7B4;
	Mon, 26 Oct 2026 08:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793026926; bh=v+zgyK0QwsGg1V453RC6kjK16TjZSW8MMUUh5EUtImA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq8fBUGGhyKB1XXODIVt6BLwqv4o1xkXZa7X2pGzhE3cWxE1Dx6V2Agz2JruU6v8B
	 e6+kt1FW/KX9OCoA7zQKe+M/qRq4dDfLlyRJhVUpUX6qmLxdWvCOV5AohG8CCGKOyh
	 lOSGCTkE5jrlgqOKG5he5sUj7qM29vi1N67m9FTc=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 01/15] KVM: arm64: pgtables: Change write bit from S2AP_W to DBM
Date: Mon, 26 Oct 2026 15:02:00 +0000
Message-ID: <at9raEVrsbb7rj6n@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <8ca88576-651a-4b7f-91ff-2cb2359aa79e@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-2-zhengtian10@huawei.com> <arxW4PUY3qqRkogl@kernel.org> <8ca88576-651a-4b7f-91ff-2cb2359aa79e@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Sep 30, 2026 at 10:44:26AM +0800, Tian Zheng wrote:
> On 9/30/2026 8:25 AM, Oliver Upton wrote:
> > Hmm... I'd actually like to see this structured where the "write" bit
> > could either be S2AP_W or DBM depending on if the system supports
> > FEAT_HAFDBS. Look at how HVHE is handled for selecting the right AP
> > encoding for the hyp stage-1 page tables.
> > 
> 
> Hi Oliver,
> 
> Thanks for the suggestion. I missed the case where FEAT_HAFDBS is not
> supported. Systems without the feature should keep the original
> encoding, with S2AP[1] as the write permission bit. I'll follow the HVHE
> pattern to select between the two encodings in the next version.
> 
> Thanks!
> Tian
> 

Hi Oliver, Tian,

After some digging, I think it would be better if we kept using S2AP[1] as 
a writable bit, while DBM can be treated as "Can promote a non-writable 
page to writable if HAFDBS=on". 

I know it's not that intuitive, as the Arm ARM even introduced the concept 
of Writable-clean an Writable-dirty, but I think it will be the best way of 
referring to what was intended of the bit.

I wrote down what I mean by that:
https://lore.kernel.org/all/20261026144413.441566-1-leo.bras@arm.com/

tl;dr: 
- DBM + S2AP[1] is set on writable entries (KVM_PGTABLE_PROT_W)
- Writable detection is made only on S2AP[1], so no changes
- Wrprotect sets S2AP[1]=0 from the PTE, and also DBM=0 if it's a block

On dirty-tracking:
- If HAFDBS=0 : no functional change, DBM bit there but unused
- If HDBSS=1
  - Pages: writable-clean promoted to writable-dirty on write, HDBSS does 
    the tracking
  - Blocks: faults on write, splits in pages, pages get DBM=1. 
  	(argh, I think we need a PROT_DBM for that) 

Does that make sense?

Thanks!
Leo
