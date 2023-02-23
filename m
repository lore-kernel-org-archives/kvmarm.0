Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5A823A5
	for <kvmarm@lists.linux.dev>; Thu, 23 Feb 2023 09:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEB1C433D2;
	Thu, 23 Feb 2023 09:53:09 +0000 (UTC)
Date: Thu, 23 Feb 2023 09:53:07 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>, Marc Zyngier <maz@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 00/12] KVM: arm64: Support FEAT_LPA2 at hyp s1 and vm
 s2
Message-ID: <Y/c3g03Ad+S2XmsQ@arm.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
 <Y5pvzKYdZK79nyZw@google.com>
 <c19594a6-358b-c0de-b1f5-84de38015379@arm.com>
 <Y5tjfmJRFY2pFlr4@google.com>
 <Y6H+uXrIrQjdntA4@google.com>
 <e16ec8cd-3b00-0b64-8a44-7cf8f34c771a@arm.com>
 <Y/Z+PfF4Dv/1hi9R@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/Z+PfF4Dv/1hi9R@linux.dev>

On Wed, Feb 22, 2023 at 08:42:37PM +0000, Oliver Upton wrote:
> On Mon, Feb 20, 2023 at 02:17:30PM +0000, Ryan Roberts wrote:
> > Apologies for having gone quiet on this. I came back to this work today only to
> > notice that you sent the below response on the 20th Dec but it did not get
> > picked up by my mail client somehow (although I'm sure it was operator error). I
> > just spotted it on lore.kernel.org.
> 
> Huh, sounds like the arm mail server is not a fan of me... Alex reported
> my messages arriving in spam as well. I'll let you decide what that
> means about what I have to say :)

Nothing personal ;), for me most linux.dev emails ended up in the
outlook spam folder. For the benefit of the Arm people on this thread,
since I added linux.dev to outlook's safe senders list, I haven't seen
any of these emails in spam (well, until IT tweaks some filters again;
in the past I was struggling to get google.com emails and the safe
senders list did not make any difference).

-- 
Catalin
