Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213466;
	b=iLTvEqc4yj0iZC3Toe9vL5ZXcVkZO0f8TSnhtdxi7wew/bM+ULBeJtBdgT+AwRTuUSn6
	 /lfqTu5kMZzuqDSAt2lP/bg67BzLYinHBOvrt/RETH3oZle2XW9TxlTfO2H7NUI2TEe9H
	 WGdRN3bSgHBMjcDRq4bs9vtzTfEx71MZnph8Z1tzbYz0cN4aF2HI/ESinkw/guXNxd9dg
	 7NHk2GW/Qch8mRA8fcnb1xWsbNASKaxH54SQqKVRVgdJ3wSSMQmNWC6OfLYqlu2dx/A4t
	 Tt+QnJX90ZSXNsPlmkkMt6Hz7nYlpq3BiRiXWPsgrRsh3dULk7O/Q/StFuwmbcaEWxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213466;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WZoDzXkOMT/5cXIMxLO4BLJijoO3XJv8ed+jm9PnUm4=;
	b=U4kfx6EKlnzyd4m6egahmyRC8Np2CvK2ViH3i3qk2HPXGaU+3Ly8MKbVm78JXDVQufip
	 Sh9+WZ/lwdpqJe/tjIW/gscRCLKe4kjHAdLrh3JlKHcqEa+fp/M97A1dKNpvTebE3S0+q
	 893//1+Lg6adzolVEw5Ehx1AIJO7JGcF+ZwBsk25yYoAtLrQ6kft9R47zMe3ye8WlEX+c
	 RJdrxNL4+ZYTHitvOr6VbY34rO+bQFosSDSe6PC1/j2C8O+SLL4I2HnMQC7yGHMQJkS0H
	 f+q+A9BxzWaWX31yhoUxYXJhp8ef3B4ipY1re6l+XPm+hTUGsS2X6a5tJ0FRl/wX4Mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RTM4X4by;
	arc=none smtp.remote-ip=91.218.175.42
Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D8606A33A
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:37:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 467D8606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RTM4X4by
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=WZoDzXkOMT/5cXIMxLO4BLJijoO3XJv8ed+jm9PnUm4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213463; v=1; x=1794818263;
 b=RTM4X4byRzy1SXDFaYAmcHV7jWm8HaQpeM88/ip8OYFy8bPCLa/otCN4ysrSWUHz8Z1c36EB
 Id3oKP9ubd7MAY2ijTybvUegDVlR/wfZ3MsbeNFl530TOyIucEhgrE7d9cGsvrgqeyhH75LdKfI
 kCOP8xvK30uOr5cMm/vqBHig=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5b4a0091992ea107;
	Mon, 09 Nov 2026 08:37:43 +0000
X-Mizu-Trace-ID: 5b4a0091992ea107
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: arm64: Support SVE in protected VMs
Date: Mon,  9 Nov 2026 08:37:43 +0000
Message-ID: <20261109083743.820111-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105130456.1617185-1-fuad.tabba@linux.dev>
References: <20261105130456.1617185-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi folks,

I've folded this into the series that advertises the rest of the
protected VM features [1], so please consider this posting superseded.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261109083205.806619-1-fuad.tabba@linux.dev/
