Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793037953;
	b=TCaY10JSIXj+TkP9RLReen9eZ8TXvnQg07GCxQLLKt91lgbo3R1oPTLs5pYL4V9AJrRS
	 V3onIfIJQON5uurlyw8WSvDHDDwy8Ut460jgE4AHImDunb217y9Wl4mAZJDoASb0WlKcS
	 ME1A52TGz6p5dV6YtbgIsq1stym3ngzbk1xXLSebf50sUwAzXtDcnBB/N9b9HXGzkUS4i
	 Sj9uaEBfq0jnw6ljI4glaTw3aFZH8CgIfEIo9SD8sfDTmyl6PSIU5TDjf/c7JluwWFawp
	 CwKs1IeRlVNcjgUx7u7ULguJmLu0+Mr8SAv+HfCmQt8hPzFJlPToykiqGK6Anr3X+2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793037953;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=Dazdfuswvplzd+nZxkdJ2Trb6gBuPhP20O43N/pReRw=;
	b=kIKPCc/FzllkiqxDIXbQHdDH+3Rw3l+RgByxEzIgymtq3yPWhxfbcWqqOoKOvQRxZxKv
	 98j12b2E1vJ5nd833LYBiKG4+4mI38MlN18rKCyM2lLLtaSf+tlLlREp7RQtMOF7xvJrF
	 V5YFde43b1191XBOlnRa8XSs//zrG+2+mOWyxi4MqJPLOpj3Xqj19tjf9R4xWBe2bIPzD
	 ZrxDf1jkQw3lQNcQnUB6JhmBB5P9yoOUrcn+u+87O1iCVx/go+Ow8ESGbb7rXZRDLnlfP
	 sTgwcVxOqX01Ek9ay9zmDuxbsAzfgY0Xz/iTK/g/lz0BZ0CqOR5+9uX95DbnDMoBkFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oiB7p4FK;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CE9606A31A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 18:05:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A3CE9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=oiB7p4FK
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7783D19F6;
	Mon, 26 Oct 2026 11:05:47 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9D403F7B4;
	Mon, 26 Oct 2026 11:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793037950; bh=0Fm//jObvS8Sn73p6wEdeeyE1A5W+WdjYk5R853HCAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiB7p4FKmQfYPhak2KyREhmAxzj21VR9bO/7IkVcr4vAhuyPU4BxeGZVArbjZCBEd
	 7nzK9K8tzkV9r//ANLZIfuLWdMzOrAyY3poD5DzLJ8uSGtE5kCj10S9IqZQr1/eDt6
	 WhdNQVWRU4yJS35XoSMSRo4NhGpvYUfZQjEkElRo=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
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
Subject: Re: [PATCH v5 05/15] KVM: arm64: Harvest stage-2 dirty state into the host folio account
Date: Mon, 26 Oct 2026 18:05:38 +0000
Message-ID: <at-WceRKAVM2kEnI@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20260929103655.85107-6-zhengtian10@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-6-zhengtian10@huawei.com>
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

Hi Tian,
Sorry for the delay in reviewing...

On Tue, Sep 29, 2026 at 06:36:45PM +0800, Tian Zheng wrote:
> With VTCR_EL2.HD set, hardware promotes writable-clean descriptors to
> writable-dirty without any VM exit, and the only record of the write
> is the S2AP[1] bit in the stage-2 PTE. The write never passed through
> the host stage-1, and no unmap path reads the bit, so the record dies
> with the PTE and reclaim may discard written guest data (silent
> corruption).

Sorry, I didn't get what you are trying to achieve here.

On your patch, I see you marking backing pages dirty at wrprotect and unmap 
walkers, and it's very confusing to me on why you are doing this.

IIUC, what you are trying to do is make sure a page does not lose it's 
contents in case it is reclaimed by the OS.

IIUC, when a page is reclaimed, it will unmap the S2 PTE, and save it's 
contents to swap, so when the guest read or write to that page will cause 
it to fault. 

The page can never be just unmaped, as if there was a single write to it, 
the backing pages should be writable, and the contents need to be saved 
somewhere. 

So, if I was able to understand your suggestion, we don't need to worry 
about this, and this patch wouldn't be necessary. 

Did you hit this issue? 
Can you please expand on your issue, if I could not describe it above?

Thanks!
Leo
