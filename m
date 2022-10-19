Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92A9185F
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 12:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61E0C433C1;
	Wed, 19 Oct 2022 12:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666182964;
	bh=P7FFwg/Wkr7el57I+MGdWjkTZOf1uSf+z9lZS/OE+e0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=El031p3Pncx0SEsDrncIw7CxIevMPN+dkSxrxG3jwDIGiorMNCLptGxzrexmxtXac
	 MZL0jhBtoJYy8eBtFcM8z2MzNwvCH+XzMUx6MBbN7hcpEb4mHxtuDAWaxdbR8VsoQ0
	 Hogd4CRnbLY8lUVBOfqY2vH/MQlU6LXRDpnejv5O2KNdtCSzyYVcBIsR5fMocQPzqV
	 YPu5MMEU6hjM66/9Q8f1FLgOGWBqozNSXgCwjWDyvAWIqzkeoAYC1J5S70Oyt5gRVp
	 ZITilSl2+i2HTi1MusZsYVassSY7k9/XWqYz2UNWL1nnaa7fHbvLIEN7eXmE7Xd0Ec
	 0eoS6B/EwgU1Q==
Date: Wed, 19 Oct 2022 13:35:58 +0100
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <20221019123557.GA4220@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07CoADQH4v7cY5Y@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07CoADQH4v7cY5Y@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Oct 18, 2022 at 03:13:36PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +/* Maximum number of protected VMs that can be created. */
> > +#define KVM_MAX_PVMS 255
> 
> Nit: I think that limit will apply to non-protected VMs too, at least
> initially, so it'd be worth rewording the comment.

Good point, I've changed this to:

  /* Maximum number of VMs that can co-exist under pKVM. */

Will
