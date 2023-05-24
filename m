Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2E618C05
	for <kvmarm@lists.linux.dev>; Wed, 24 May 2023 14:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90608C433D2;
	Wed, 24 May 2023 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684937909;
	bh=iPu+cmPH/20drEbzpurGyw6T9vj1hYqEynqQowFUtSM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oeuzeFJcKbpQDqq2PHqkKg1JzsViwGv7DRgg7t2qDAzQBIV54G7DXhj2L8tioHhLz
	 TbVh6oVV//GNiz6rfsG+9Y33hi8rtHgwvE0evFwhMaUF6aZORNbkPbU79dXrXtzKh4
	 kOTCiUBF/JTWPPwNNltEGkKbUvhgMoAiYZeyFgenwcKPwgQHE5G5TXqwlOzs+tExHl
	 /uFiuDBwANAVLgRw0hYkTGmqsdhefQGrwGqGCx8lL770cs6cx6Q3KGe1urc5bg1w9A
	 Ye0MkH/X4d+dz8SqFuX1NRCa9AH9GIXBT7NPFGzeL2wv4wpXV/Z9Ij2ZRae11mLtDY
	 Yyk8hhFz3F1Ig==
Received: from disco-boy.misterjones.org ([217.182.43.188] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1q1pJr-0003gu-46;
	Wed, 24 May 2023 15:18:27 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 24 May 2023 15:18:26 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>, Oliver Upton
 <oliver.upton@linux.dev>, Quentin Perret <qperret@google.com>, Steven Price
 <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: Re: [GIC PULL] KVM/arm64 fixes for 6.4, take #2
In-Reply-To: <20230524125757.3631091-1-maz@kernel.org>
References: <20230524125757.3631091-1-maz@kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <e6baaa4dbb813cd46c41d079154e3e15@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.182.43.188
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, cohuck@redhat.com, tabba@google.com, jean-philippe@linaro.org, oliver.upton@linux.dev, qperret@google.com, steven.price@arm.com, will@kernel.org, kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2023-05-24 13:57, Marc Zyngier wrote:
> Paolo,
> 
> Here's the second batch of fixes for 6.4: two interesting MMU-related
> fixes that affect pKVM, a set of locking fixes, and the belated
> emulation of Set/Way MTE CMO.

OK, $subject is an indication of what's on my mind...

But please pull anyway!

         M.
-- 
Jazz is not dead. It just smells funny...
