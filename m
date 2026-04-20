Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CF82C326C
	for <kvmarm@lists.linux.dev>; Mon, 20 Apr 2026 05:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776662883; cv=none; b=giYcwXxzTpFOcEAIxGet3Ckgc4LqcUWBJLyjXj7/1aVg2uFz+Fk2ZbtZ28T1aGxyCyOfY6s1fTC7OIJ+2h+VbcM2q5R2ROVAY7n/iqiMiPul2iN+my3XKwdXcnUAU9VrBTe7pnIh4NH2qx/4m/tolcm+lJXmhhpVhuxZ4IXaVhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776662883; c=relaxed/simple;
	bh=5pFfAh0w8FoorL1tj4Eo6xVJ2XthVkrf9fRKjTtD1aA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aCol5gBWtplZkjvZjew1qX76H11OXW7lnGp8jA/UBceDG5BIiohR+pAKx+YotZtZI4WoqIN/eO5r3DAu5MTH2O956/fgaN5pXT6y8ejx5pS0Hug5IqG1CBxlaKIHRrEAgH1PxgCNP/js6SSKan+vl+N3pgBv6jb3DxtM8+fCf/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=O/7mWMQ/ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="O/7mWMQ/"
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63K5R9l2040505
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Apr 2026 14:27:09 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=zYqBi5Y7SR8juLwBRICUsdi/c0VzNDgvxNB9NS9Ihhs=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-ID:To:Subject:Date;
        s=rs20250326; t=1776662829; v=1;
        b=O/7mWMQ/1Txgcq83Zz62yWSSux2cnql95+dF4NKmTQQ36GGq2zOlxgygimjHS7rK
         QO7SJEiAYsGCw2hyAEfp2dxSbmYksGEpyKjIkX9sAqfsqFOR20VCHYv4OF8mYYJk
         dn/kGNqtvWlBLp9fo2rwzsgifb1A3Xkmk9OnmIUicx1UuVhgl24WCAT0FuTdxnfw
         n9R/xRc2LawyKhC0rslMiN+blLIKkm8vjADTYVdqIy74ZkN1uG6yMkBuiaAVDd2u
         YorDbuNva9Uk1LlmuoiGaPVrt3yrY3OSUzujy4uXsa5F+tVVTRy9a6MYN/c7xjNQ
         5cBa22eQ/DJCl3bNh4hiTw==
Message-ID: <73cc9b30-091d-44d6-8a57-d4aa97ad678c@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Apr 2026 14:27:08 +0900
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/4] KVM: arm64: PMU: Add
 kvm_pmu_enabled_counter_mask()
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu
 <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, devel@daynix.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260418-hybrid-v7-0-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
 <20260418-hybrid-v7-1-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
 <87o6jfavhx.wl-maz@kernel.org>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <87o6jfavhx.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2026/04/19 23:13, Marc Zyngier wrote:
> On Sat, 18 Apr 2026 09:14:23 +0100,
> Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>>
>> This function will be useful to enumerate enabled counters.
> 
> Consider expanding this commit message a bit. Something along the
> lines of:
> 
> "Add kvm_pmu_enabled_counter_mask() as an accessor returning a 64bit
>   mask of the counters enabled on a given vcpu.
> 
>   This will eventually be useful to iterate over the counters."

That looks better. I think I'll use that message for the next version.

Regards,
Akihiko Odaki
