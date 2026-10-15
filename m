Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04453E4C95
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792081955; cv=none; b=iHEZcaqnHVokk1m+XedmyJJtk/TuQWeC1BXxcbkQpwEZ+V/0Sa7t4UqJQib/ahEstsCZA4MUW8zncIhc4yrhm9nReILxn8iEtXvRXcAjIJpty7BdAQGVSfxfm3heGvDrhE2OKHpFxBmlY5qetDMdJh0h7MjX8u9ODj7rnT/oyeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792081955; c=relaxed/simple;
	bh=K53bHe/qRL8PgX+fC0aZ/IKukdzfGE2CeH1J1pXxbIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c7MtkRexhPSWhNputMXbqoOJGdewTWDw/NesXIpDsWduda4y8E1PUumQfXGW9IhWLsBaU6c5Z7/6Wk/yMcMRrTxOgmHZeIIm3DaJqjoydWOAOLEt5vPNcL5PluiZieN4nF/Pwile5hvcbrsLst64hTmKOUfu98rrWJIsJatUU6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=QvHiuvww; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="QvHiuvww"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A328614BF;
	Thu, 15 Oct 2026 09:32:19 -0700 (PDT)
Received: from [10.0.138.89] (XHFQ2J9959-5.cambridge.arm.com [10.0.138.89])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E966C3F871;
	Thu, 15 Oct 2026 09:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792081942; bh=K53bHe/qRL8PgX+fC0aZ/IKukdzfGE2CeH1J1pXxbIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QvHiuvww2XMiC1VH5lrEn7YT52tcUfUfqnhqZ6AL7/+1oS59HDeC1lXKxNrpFi1pC
	 t0SbzJpTfupyKQqZc3bVVGYXHq188MRT6NrH01zSEEbyjpLbZx7PQxzYaj0Ht2nEy2
	 xPD7PUul+C++YYvpS1ogXhTXImp3VMZKjPrCVxsE=
Message-ID: <e8d97f6c-8e22-4c85-b15d-6edade16d789@arm.com>
Date: Thu, 15 Oct 2026 17:32:18 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/15] misc/arm-cla: Add launch operation helpers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 Oded Gabbay <ogabbay@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, devicetree@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
 <20261015142552.4128028-3-ryan.roberts@arm.com>
 <2026101542-briskness-most-a8ca@gregkh>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <2026101542-briskness-most-a8ca@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/10/2026 17:17, Greg Kroah-Hartman wrote:
> On Thu, Oct 15, 2026 at 03:25:36PM +0100, Ryan Roberts wrote:
>> From: Jean-Philippe Brucker <jpb@kernel.org>
>>
>> CLA commands are issued by writing optional payload registers,
>> programming the LAUNCH register and polling LRESP until the hardware
>> accepts or rejects the operation.
>>
>> Add a common launch helper that performs this sequence on the CLA's
>> local CPU, waits for LRESP completion and translates launch response
>> codes into Linux errors.
>>
>> Build accelerator reset and register read and write support on top of
>> it. The register read and write helpers split larger accesses into
>> multiple launch operations when an access crosses an eight-register
>> window.
>>
>> Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
> 
> You forgot to sign off on patches from others :(

Ahh sh*t, sorry about that. Hopefully given this is "just" an RFC that's not a
big deal? Else, let me know and I'll resend.
