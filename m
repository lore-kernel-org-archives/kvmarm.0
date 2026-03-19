Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5DB37E2F4
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773916715; cv=none; b=CBnN95xRnJjcLpyHQkcPEWHAHGj8lQXibILvf6d+Jr6h1oVT+Jv1x0CVKVPa7jRgkrbXkT/fEszQw4zfkVZBVMqPnSnpv9NHN8lF5UpUmbFXziojDt88REb3R2JJGmT09CTXuRBtfQ+PQCIAyjIMHmtnYsvqTlGvbbzwVBKXI0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773916715; c=relaxed/simple;
	bh=ffuXN//p5iDx8+jkaR2Jg1K5deBAldvp45ErxUHueIE=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qc+jbTlefvvankeVafzpefxJsQ0DvZ8X6e1L8nKyjXJdyPnrymZLAlKLnqOulfjJBWUK8qdwbSqo6PDJSbaVS0F5spsVMzlWy0nPjbRhJtyPohDizHwweCassVzT6FRjOMCXjbppNpTyXt6oePrp57vKbIdTVFFN5yZ1NP7/AdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=uY8Tu/+Q; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="uY8Tu/+Q"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=G/yWvs+u+2ox5r2RC2KJBHK3Mv2sQaP76wNy2i2+g+k=;
	b=uY8Tu/+QmqJx89Fu6/4iVzerjZ3SA/lL2P6iA/PuYikQcxBBeLzHAIqhAMhEjNnlm1Pb8XU6F
	/cPLkPqSi8oMF3fwYxG/tvlc/e8EhrbsTGH6L87Wk9k8LlYEHhZsrtSJYOcefmMYK1o4GmKCt+J
	xc1w3GFBFN+p1lXGaE6uncE=
Received: from frasgout.his.huawei.com (unknown [172.18.146.32])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fc2Bd5VDGz1P7Fp;
	Thu, 19 Mar 2026 18:34:49 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fc2GN5cxDzHnH8Z;
	Thu, 19 Mar 2026 18:38:04 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id 1CD524056A;
	Thu, 19 Mar 2026 18:38:28 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml500005.china.huawei.com
 (7.214.145.207) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 19 Mar
 2026 10:38:27 +0000
Date: Thu, 19 Mar 2026 10:38:26 +0000
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Sascha Bischoff <Sascha.Bischoff@arm.com>
CC: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, nd
	<nd@arm.com>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, Joey Gouly <Joey.Gouly@arm.com>, Suzuki Poulose
	<Suzuki.Poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"peter.maydell@linaro.org" <peter.maydell@linaro.org>,
	"lpieralisi@kernel.org" <lpieralisi@kernel.org>, Timothy Hayes
	<Timothy.Hayes@arm.com>
Subject: Re: [PATCH v6 14/39] KVM: arm64: gic-v5: Trap and emulate
 ICC_IDR0_EL1 accesses
Message-ID: <20260319103826.00004be1@huawei.com>
In-Reply-To: <20260317113949.2548118-15-sascha.bischoff@arm.com>
References: <20260317113949.2548118-1-sascha.bischoff@arm.com>
	<20260317113949.2548118-15-sascha.bischoff@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml500005.china.huawei.com (7.214.145.207)

On Tue, 17 Mar 2026 11:43:34 +0000
Sascha Bischoff <Sascha.Bischoff@arm.com> wrote:

> Unless accesses to the ICC_IDR0_EL1 are trapped by KVM, the guest
> reads the same state as the host. This isn't desirable as it limits
> the migratability of VMs and means that KVM can't hide hardware
> features such as FEAT_GCIE_LEGACY.
> 
> Trap and emulate accesses to the register, and present KVM's chosen ID
> bits and Priority bits (which is 5, as GICv5 only supports 5 bits of
> priority in the CPU interface). FEAT_GCIE_LEGACY is never presented to
> the guest as it is only relevant for nested guests doing mixed GICv5
> and GICv3 support.
> 
> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Does what I'd expect.

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>


