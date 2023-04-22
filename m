Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E6F7F
	for <kvmarm@lists.linux.dev>; Sat, 22 Apr 2023 09:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504C7C433EF;
	Sat, 22 Apr 2023 09:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1682154341;
	bh=VGbn/V1aNHTdvq73sdS9rOybUDMt2gl58gvTgoHnREw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sYzC9LUXcnvJeD7IvDzWnoYkx9DfLe/uA3CNcOwufJmnbBf+GTV+ZsMjVGti0crlN
	 TX+n/pKJQ2kijtnDzIgH5M6Pbwdq5VGrQgR58IYBpluBBoaHJecKwrp8G/HuKdylMT
	 EnLc2t4Hd99K7TDCnbZO6tePUge/kWA+Z1FKgMfnNPM3NEw0v6urK+2Qc3pcV77Vhq
	 xRMehpEQKuFmXhAQiRdONDW+Mo3TwmC3Sqz1KqWVk7adt3BdS1ICaA4+qDmi+BHZ+a
	 w/+5SCwuo9oE02EqTAT8jxipmO9ISMLbRuVjP0urqL0sjtc+G0k9zib7e1WW6EfbqU
	 Nth96uACVfLpQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1pq9Ba-00ARn7-Sk;
	Sat, 22 Apr 2023 10:05:39 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Sat, 22 Apr 2023 10:05:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Will Deacon
 <will@kernel.org>, Mostafa Saleh <smostafa@google.com>, Dan Carpenter
 <dan.carpenter@linaro.org>
Subject: Re: [GIT PULL v2] KVM/arm64 fixes for 6.3, part #4
In-Reply-To: <417f815d-3cf1-45ea-eba7-83e42f249424@redhat.com>
References: <ZEAOmK52rgcZeDXg@thinky-boi>
 <417f815d-3cf1-45ea-eba7-83e42f249424@redhat.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1023162f05aac3b460effa4a7baa0760@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, smostafa@google.com, dan.carpenter@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-04-22 00:51, Paolo Bonzini wrote:
> On 4/19/23 17:54, Oliver Upton wrote:
>> Hi Paolo,
>> 
>> Here is v2 of the last batch of fixes for 6.3 (for real this time!)
>> 
>> Details in the tag, but the noteworthy addition is Dan's fix for a
>> rather obvious buffer overflow when writing to a firmware register.
> 
> At least going by the Fixes tag, I think this one should have been
> Cc'd to stable as well.  Can you send it next week or would you like
> someone else to handle the backport?

Indeed, that's missing. But yes, backports are definitely on
the cards, and we'll make sure all stable versions get fixed
as soon as the fix hits Linus' tree.

         M.
-- 
Jazz is not dead. It just smells funny...
