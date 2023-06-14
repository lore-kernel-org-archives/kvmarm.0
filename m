Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F58D11184
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 16:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096B2C433C0;
	Wed, 14 Jun 2023 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686759368;
	bh=Ks4bJ0TA9BrpfxeV3RYH48Yuda10fqlRYYmTIBuBuCo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HXOPnP8S6xg5toWS4sF24QdreIb7t5QSXBu+BEueRUgQD0FePERQS92qJLcr5kBUU
	 Ytlq+PbcMosjSQpd6YugPVlkiVeCDHY+UeJEoizlGFjNSxMFSk81JWJcfg2yyHl5U3
	 9/WBJzVfSZquZ+EgdX+nU7yIEx5jyccWr97GEXQtcnZrgBMmplzJ47830pAkSLTtcN
	 KveEbbM0P9EFsP6EdAtbcEOYnoX3fR71kaIHxn/JhMSSSUfWtAJZNuHa1ufLvwaPdT
	 IvjnihOHgkiF8RGKA5NIeRn1pwx6yefJyS+Ib8/RCxlWo6TLZ6hmTZlrFfuCU+bWOX
	 mmhGjMNaEwgfA==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q9TAD-005NaV-M1;
	Wed, 14 Jun 2023 17:16:05 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 14 Jun 2023 17:16:05 +0100
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Quentin Perret <qperret@google.com>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, Fuad Tabba
 <tabba@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>
Subject: Re: (subset) [PATCH v3 00/17] KVM: arm64: Allow using VHE in the nVHE
 hypervisor
In-Reply-To: <168675651876.3255755.11650251411681563144.b4-ty@linux.dev>
References: <20230609162200.2024064-1-maz@kernel.org>
 <168675651876.3255755.11650251411681563144.b4-ty@linux.dev>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <7499530a98f6f9e9532f4cf72921a1ad@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, qperret@google.com, will@kernel.org, james.morse@arm.com, tabba@google.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-06-14 16:31, Oliver Upton wrote:
> On Fri, 9 Jun 2023 17:21:43 +0100, Marc Zyngier wrote:
>> KVM (on ARMv8.0) and pKVM (on all revisions of the architecture) use
>> the split hypervisor model that makes the EL2 code more or less
>> standalone. In the later case, we totally ignore the VHE mode and
>> stick with the good old v8.0 EL2 setup.
>> 
>> This is all good, but means that the EL2 code is limited in what it
>> can do with its own address space. This series proposes to remove this
>> limitation and to allow VHE to be used even with the split hypervisor
>> model. This has some potential isolation benefits[1], and eventually
>> allow systems that do not support HCR_EL2.E2H==0 to run pKVM.
>> 
>> [...]
> 
> I decided we should probably should have this in -next for a bit before
> sending a pull request. We can shove any fixes on top as needed.

Awesome, thanks. There's already one such fix on your way!

Cheers,

         M.
-- 
Jazz is not dead. It just smells funny...
