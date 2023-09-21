Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F928946D
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 11:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF4CC4AF73;
	Thu, 21 Sep 2023 11:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1695294791;
	bh=iw3ke3UbjDTAN2nBHhwP4e/dfZNBea9LZ0dNzqIP5iw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oVL3zEiZWx1Ni36n69czmH8Rndi0lBbS0Etby6v6VLdrb/eCFWzGQWOcyjO59CZT2
	 ddokokVjzOBmgBan+iAuFcfs4nHYzcymRO5YV5ArAgGX6r3XCr9Ngdtxza2FsY6oAm
	 CuBGcqIhcCjt1tYjwszkhisv7eUM85hGImAVdBA9WwMbvoZccBPKeJLjXxYh5+haS1
	 fvXoYM2iWqGeJKJ6Oo75Pl5p3HjJ6WliEv1/7V1lwKsxQJrL4MMQOc7y9ioD46sOxH
	 IEgqLfDj/WDhZn1+1RRKuoeEJ71Q3lzPKuwCwhnNL9PIJfcd1NKxetDhrcgEsfJQfr
	 J4lvP+TUI2bhQ==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1qjHcL-00EuE8-4R;
	Thu, 21 Sep 2023 12:13:09 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 21 Sep 2023 12:13:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: Joey Gouly <joey.gouly@arm.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu
 <yuzenghui@huawei.com>, Shameerali Kolothum Thodi
 <shameerali.kolothum.thodi@huawei.com>, Xu Zhao <zhaoxu.35@bytedance.com>,
 Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v2 03/11] KVM: arm64: vgic-v3: Refactor GICv3 SGI
 generation
In-Reply-To: <20230921094225.GA2926762@e124191.cambridge.arm.com>
References: <20230920181731.2232453-1-maz@kernel.org>
 <20230920181731.2232453-4-maz@kernel.org>
 <20230921094225.GA2926762@e124191.cambridge.arm.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d905e62015f27949c3c08c7579e489ca@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: joey.gouly@arm.com, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-09-21 10:42, Joey Gouly wrote:
> Hi Marc, Oliver,
> 
> On Wed, Sep 20, 2023 at 07:17:23PM +0100, Marc Zyngier wrote:
>> As we're about to change the way SGIs are sent, start by splitting
>> out some of the basic functionnality: instead of intermingling
>> the broadcast and non-broadcast cases with the actual SGI generation,
>> perform the following cleanups:
>> 
>> - move the SGI queuing into its own helper
>> - split the broadcast code from the affinity-driven code
>> - replace the mask/shift combinations with FIELD_GET()
>> 
>> The result is much more readable, and paves the way for further
>> optimisations.
>> 
>> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
> 
> Want to point out that I didn't review this code, I only reviewed 
> patches 1-3
> from the original series.

Ah crap. I try to make sure I was only tagging the right patches,
but obviously failed... :-( Really sorry about that.


> https://lore.kernel.org/linux-arm-kernel/20230907100931.1186690-1-maz@kernel.org/
> 
> Since it seems Oliver is picking it up, can you remove my r-b tag from
> this patch.

Well, Zenghui has found a couple of issues, so there will be a third
revision for sure. I'll amend the patch right away.

Thanks,

          M.
-- 
Jazz is not dead. It just smells funny...
