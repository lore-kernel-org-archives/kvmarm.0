Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7456133E6;
	Wed, 14 Dec 2022 09:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BDAC433EF;
	Wed, 14 Dec 2022 09:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1671010996;
	bh=uut+hV+py5emy6howSBFzXtArJVZljieADDyI0cWYpo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cPLmhgJKLNx4gsb0xlxx3yfRK1F7tY1cR6GGJ9ucvTrjU8d7XbVcWxz9sj4nz76pn
	 3XWCoQhtzjzJg0NF0942XNAGNKnWLlwARVvkb5nGW99BbAwsVKs1HSxvNsfLNewdJr
	 fOu545yq7Ho1HliIFRi8gkhBXysWBWGWk1qwNKoYTs8v2Bz1T3FYVAywCKIs24nBZf
	 aMYQT3vivDNLhoG7WiRBdEooKYCTz47hbRPwdXZdN0uh5xgrP8ij1CUNdkoPd4CBOR
	 dLgWp/6xBbV+ByOIeXM0E0dBYiNf3Jl3s+W9tS1GZGUNRizztiScmuN9fn615e3zcG
	 vCApSYl6i7FbA==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1p5OID-00CZta-P7;
	Wed, 14 Dec 2022 09:43:13 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Wed, 14 Dec 2022 09:43:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Nathan Chancellor <nathan@kernel.org>, Nick
 Desaulniers <ndesaulniers@google.com>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Tom Rix
 <trix@redhat.com>, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org,
 llvm@lists.linux.dev, linux-kernel@vger.kernel.org, Ricardo Koller
 <ricarkol@google.com>, Aaron Lewis <aaronlewis@google.com>, Raghavendra Rao
 Ananta <rananta@google.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH 06/14] KVM: selftests: Rename UNAME_M to ARCH_DIR, fill
 explicitly for x86
In-Reply-To: <Y5jadzKz6Qi9MiI9@google.com>
References: <20221213001653.3852042-1-seanjc@google.com>
 <20221213001653.3852042-7-seanjc@google.com> <Y5jadzKz6Qi9MiI9@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <edd6f54afb8c6e8e83d57d3c9162ecbd@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: seanjc@google.com, pbonzini@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, nathan@kernel.org, ndesaulniers@google.com, james.morse@arm.com, alexandru.elisei@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, trix@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, linux-riscv@lists.infradead.org, llvm@lists.linux.dev, linux-kernel@vger.kernel.org, ricarkol@google.com, aaronlewis@google.com, rananta@google.com, dmatlack@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Message-ID: <20221214094313.GpBFAdVR48k0AdGl1RNhZubmUdLKRg1cQLUkvPUU3hU@z>

On 2022-12-13 20:03, Sean Christopherson wrote:

> One last thought/question, what do y'all think about renaming 
> directories to
> follow the kernel proper?  I.e. aarch64=>arm64, s390x=>s390, and 
> x86_64=>x86.
> Then $(ARCH_DIR) would go away.  The churn would be unfortunate, but it 
> would be
> nice to align with arch/ and tools/arch/.

aarch64->arm64 makes sense to me. Whether it is worth the churn
is another question. As long as we don't try to backport tests,
the damage should be limited to a single merge window.

           M.
-- 
Jazz is not dead. It just smells funny...
