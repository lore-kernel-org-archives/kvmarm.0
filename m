Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC90BE58
	for <kvmarm@lists.linux.dev>; Tue, 13 Feb 2024 00:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707784838; cv=none; b=iHMD7IZrygJKWNZEOKSs9lflWmMXZkEBSYzG4QwU5aCfrWNLCN+44nraNH93RNF5+Bf5BiZUOBi4LE6eH21LoSSVJDzBFKCwpZhZ+kViW3ZlhOE4sO+TVA8VWH3hzNqLenHVsIZvntMqGJQ/vY5gc+uJJgI5qajN0PBmRt3RA/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707784838; c=relaxed/simple;
	bh=aX0NGQtSQ1xOstbOgtF2F5o9CPGIRMm4cz8XxG3lAok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6AtWCpA2mkAYkjw6kzi4/l/a6O7WXwefiv2hSv8oD7MiokE3LNAsjCQqra2K+K7r66EdLi+5IqUOlwX7MoBJZ914kYUQ1CZy4Adb6hd8M2eNXCYKRpfZmAmLU4umoPqzrfYjmlkwC7c9WRzmak6SZODP36D5raluA0TKeI6Wk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wGH21jOa; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wGH21jOa"
Message-ID: <5c7d908b-5bc1-ce0d-6443-545eced3a0ec@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1707784834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r413WKpLLWVqOcLrWckL+PNTc7epKr5Ir5tZXNeWWGU=;
	b=wGH21jOaJ20VcTOw06Zs+ZVaNr26HquiaHNbWicq79AGbGdB4XjcpLyxnsSgSG+s4NvjZl
	E5wGp8sIm8GqbAlFojP2BaOy12bCOIFHaBtZCYLUbgyHv2j8wG74CzKA1BsejeRcgpRSUC
	A8XqzzPslueRaC8LW7/08YUN3a03PwE=
Date: Tue, 13 Feb 2024 08:39:56 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] KVM: selftests: Print timer ctl register in ISTATUS
 assertion
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Raghavendra Rao Ananta <rananta@google.com>, linux-kernel@vger.kernel.org
References: <20240212210932.3095265-2-oliver.upton@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20240212210932.3095265-2-oliver.upton@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2024/2/13 05:09, Oliver Upton wrote:
> Zenghui noted that the test assertion for the ISTATUS bit is printing
> the current timer value instead of the control register in the case of
> failure. While the assertion is sound, printing CNT isn't informative.
> 
> Change things around to actually print the CTL register value instead.
> 
> Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> Closes: https://lore.kernel.org/kvmarm/3188e6f1-f150-f7d0-6c2b-5b7608b0b012@huawei.com/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
