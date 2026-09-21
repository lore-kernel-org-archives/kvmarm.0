Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24487420469;
	Mon, 21 Sep 2026 20:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790022023; cv=none; b=l64vji35iovNHyL1up+2EzFIwFkk9eWUJyLGtSX0n5fUjA+zAD6bHgKUX5B7Wg/ibjnxmlpmeVLu6RRRfC2YoAOrnPuC9p2eR7erJhIjCb9QT2wQkejODq7DDIoi7vNtIbjbdap1zcUEaAWNMoVKHzTRyJezA0AlsepCPE1QLoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790022023; c=relaxed/simple;
	bh=JtykKgqo+f211SbFKgghZZ2s4s0O43HbHIIra7rXxb4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhhzrOXndqOkEFz2razQROZrIbCYniVCCzI/fvvIZ2V9szF5TtiIRG9N9tU3OrJPVWP22GQ0NV7YUNnAw+veuu6hY/YBaVQPsKms1MWZZYNzM4cKyQ9ydMmoJdV2p/ZeHmoNGy9P/wuu1aef9Ujbxr/m1DFGyvUgVtwb547VN+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EpKzmRij; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EpKzmRij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FD01F000FF;
	Mon, 21 Sep 2026 20:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790022021;
	bh=DSZiEtwE1uacP7iFOeCfIa6zqRHcapIJW8XH08Z+dxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EpKzmRijiEzN+ngovxGMDwJKFJeQ2p8zxUZ2ELAUP5ZX3aH5mmjdKcjB23Xcui26Y
	 DNzSM9QbDJB7kM2T0dotHeN1jiMXolgz2FFl2OUYT4PeyaTwoB9sYdLCSMRkvCEZ7t
	 4O8pKUsfzFYRe4KTTxjK4vBTmINcmgeMEVRFLtFqWm/UldS7ydThDSex+ews5gnEQ8
	 hfjWhD7bTQTmP2Sf52eg9Iy6SurqA7TF9pEZUh+GZlmEWh1IL07rn5VhKoQT6e7Sgn
	 Fujl6SkeU74eLu7uqVpSXPAkkEgMHYUyCrecvCLfoORp2JRQTDmohMZXp+fUeCt8X7
	 oG1sP4TJ4aRRQ==
Date: Mon, 21 Sep 2026 13:20:20 -0700
From: Oliver Upton <oupton@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix arm64 sysreg header dependencies
Message-ID: <arGRhHgP_izSwW4T@kernel.org>
References: <20260902134118.2718200-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902134118.2718200-1-fuad.tabba@linux.dev>

Hey Fuad,

Thanks for the fix here.

On Wed, Sep 02, 2026 at 02:41:18PM +0100, Fuad Tabba wrote:
> ---
> Unlike the two existing sysreg-defs.h rules, this one's recipe is a recursive
> make, so its prerequisites are not the recipe's arguments. They only decide
> whether to recurse, which is a question tools/arch/arm64/tools/Makefile already
> answers. An alternative is therefore to drop the two explicit inputs in favour
> of:
> 
> 	$(GEN_SYSREG_DEFS): FORCE
> 
> leaving that Makefile as the only place naming the generator's inputs. Both
> forms regenerate the header and rebuild the dependents in the same invocation,
> and neither rebuilds anything when nothing changed. I kept the explicit
> prerequisites so that the recursion stays conditional, but I am happy to respin
> with FORCE if you would rather.

This might be the better approach at this point. In the unlikely event
that new dependencies get added to the kernel side of this, I'll give it
approximately a 0% chance that the author will update this rule :)

Thanks,
Oliver
