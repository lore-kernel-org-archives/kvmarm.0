Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E25E6423A7E
	for <kvmarm@lists.linux.dev>; Mon, 18 May 2026 12:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779108247; cv=none; b=pnLhzDGeMJ4KgMJjdeOvWF0LKCx8tFNfzb/B8dkFp6eBg8gnqUfTfoP/mCnv84qXgYZWyIAudq9rYWHLky8GR21sMZr0pnCYhh8uplJgtGabiwk1hkfYXqJoXTQCEtiSSe7dPPcIRG/RW37U8c1CMDYPxRucJPBxU5SZiTPO7Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779108247; c=relaxed/simple;
	bh=3dAlYnA+hJI7vcCyQEEyOLE4qbHUiQcGon50aXQTdcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PH6H8kDlfqrm/DWGCREFaHFmaQHOSxNlCtVbAoixQ664KgwrYqAaAqzWFeueaiYevQoDzgiO3GhsUBoBiMbAA14xP+j5Gd64BMcnDoLr4cW/V9wTxmRlWAdBGZ59J+a5HSzdg5MLFVUyXqxTZUD5xjBhQmsjrS0tbbEf94WOTGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WoUUZD9v; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WoUUZD9v"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F93E45BF;
	Mon, 18 May 2026 05:44:00 -0700 (PDT)
Received: from [192.168.178.24] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A9103F632;
	Mon, 18 May 2026 05:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779108245; bh=3dAlYnA+hJI7vcCyQEEyOLE4qbHUiQcGon50aXQTdcs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WoUUZD9voHWXUot87KiDH0JogiXqdEg3hSyuGjDsRLrjwAVGW/tC+6CTKxuFxvCae
	 IW8N74ViRswPYchbIclcMCLBm1LcvfxJ4IVeNdx2JUIImDeQnZ3QyxbjO85tS8GWUE
	 d4QpM+tOdKibw2GizGdpNVtYmAgxmxx95b9Kadlc=
Message-ID: <2bf66d25-940b-4eb9-a326-16da8f7c43f9@arm.com>
Date: Mon, 18 May 2026 14:44:02 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v7 0/6] arm64: Nested virtualization support
To: Will Deacon <will@kernel.org>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>, maz@kernel.org,
 Sascha Bischoff <Sascha.Bischoff@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Alexandru Elisei <alexandru.elisei@arm.com>
References: <20260323164717.2571585-1-andre.przywara@arm.com>
 <agr8f9iPNySizL9l@willie-the-truck>
Content-Language: en-US
From: Andre Przywara <andre.przywara@arm.com>
In-Reply-To: <agr8f9iPNySizL9l@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Will,

On 5/18/26 13:48, Will Deacon wrote:
> Hi Andre,
> 
> On Mon, Mar 23, 2026 at 05:47:11PM +0100, Andre Przywara wrote:
>> This is v7 of the nested virt support series, correcting a previously
>> reported, but unfixed issue with endianess. Other than that just
>> rebased. Changelog below.
>> ========================================================
> 
> This looks good to me, thanks. Unfortunately, it conflicts slightly with
> some of the other changes that I just picked up. Please can you rebase
> and resend so I can apply this on top?

Sure, will do, mails incoming ....

Cheers,
Andre

