Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447922;
	b=LQ82fJ3oqMtm1fJsX1zP2o2SYQ2eSj0hJwHMfxi6xNagK0bidaJjFgbICaiiToTg62PH
	 R21uo1E4Pq4+QcUge2zwI1anJk1VCmHMe71jwt8oQgUoIuh9Qu3DesKes6hsYsETHLizL
	 37SOdIgdxwV+rVtlWCli0XgO5Td2+4luCzQGXYiahetFF54NcsBxHsD6fi/ONFMpEvSlo
	 dZ7Ko7mH+XPxluxvFRjfshjUmLzwoNBnyM8EedgTh694waivM8DGv96TJ30bpBlqnoqwe
	 71TvmP+clSZk1AU9IwLrP68p1zuCPi9kZUeuEWpdQx4NZJR9xwFTGuYuQ3llfPMdLow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447922;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IcrKa5wszJlz7KzbvkJ6LYVb8H5e9hHDr4RZJLHWMyM=;
	b=zw4FjeolIBYEgBI/fGD8Fn8d4EFNPE46ORQons1GjpGJMzWtvU+9DbzVFm6TGah7mDRa
	 10atLbTc+XvRgXx9dcwxluuthPZlxDfJdEfqbY1IK6M5+tG+zVOXBqZNfGmoT3T6Rlf9L
	 4JpKoVm+vOLOZdwztd6L4tj7/cEs6fYf58Ip+5/gIeBFPlmZU3dBsTyXgZMvPrUEXAQz0
	 d22ByA93M1u8NPPEouylruIV+1ojuBdYVK8+TEkIMv4lUtXjOPgiqSV/3CJu3QbG3czIN
	 5SEEOmDI8w2yl2P9/+7a47Ey9WS/7iVVQvYbSRXOhRO8Ci2ajJoUZmnzL0GLmgafggg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="FTdZLh/o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F45606A31A;
	Mon, 23 Nov 2026 15:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FTdZLh/o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83C61F000CF;
	Mon, 23 Nov 2026 15:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795447922;
	bh=IcrKa5wszJlz7KzbvkJ6LYVb8H5e9hHDr4RZJLHWMyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FTdZLh/oKelhDZHb27a8Rjnsbjd5T8QMS1HZ8GXSbzFfWDBRtRlPqH4ej2BHiOxGp
	 WYaG6MaU2vMTrbJ2jSAAcXK9hewWa08MSj8aSICWcGhhEsVOS7vtEyJuqDySVj2hk2
	 Dkbnv40jW4fYWr27uMMqSLIBFptb63TGD5lwieU/2Yct6tGqap3hZNpP0fJ8syioa/
	 Bcv7nFUbzMX561fxkGAC1Fjoy5qVB1c4rTAaAEm4FZQKOlm8aqCDLyYqU9w5h9LWcw
	 0CHylaAYpxeKP3qe2jsGkle32VHGhSGNKBQ2rXU8WUrZTF9cqIvapDfYcuIc2A7kih
	 sWlm3f0Xg74pw==
Date: Mon, 23 Nov 2026 15:31:54 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, kvm-riscv@lists.infradead.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: Warn userspace against ioctls while an exit
 is pending
Message-ID: <awRcDlU6vFaL3uKt@gremlin>
References: <20261123113435.1170711-1-fuad.tabba@linux.dev>
 <20261123113435.1170711-3-fuad.tabba@linux.dev>
 <awRKhCne0gG1gKZN@gremlin>
 <CA+EHjTyM4_P5v0cHEiarq5XAb2A0Esshb762BLuuKnyBvH=y+w@mail.gmail.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyM4_P5v0cHEiarq5XAb2A0Esshb762BLuuKnyBvH=y+w@mail.gmail.com>

On Mon, Nov 23, 2026 at 03:23:58PM +0000, Fuad Tabba wrote:
> On Mon, 23 Nov 2026 at 15:09, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> [...]
> > Very much agree with Sean's take here that we should instil sufficient fear in
> > users at doing silly things (also in general not only KVM :).
> >
> > I wonder if we could add some specific examples or broad description of why it's
> > unwise for better effect, though? Comments below.
> >
> > In general though:
> >
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Thanks!
>
> > > ---
> > >  Documentation/virt/kvm/api.rst | 11 +++++++----
> > >  1 file changed, 7 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > > index 89eb6be9bc6e3..980ef0cdc1c91 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -6974,10 +6974,13 @@ to the byte array.
> > >
> > >        The pending state of the operation is not preserved in state which is
> > >        visible to userspace, thus userspace should ensure that the operation is
> > > -      completed before performing a live migration.  Userspace can re-enter the
> > > -      guest with an unmasked signal pending or with the immediate_exit field set
> > > -      to complete pending operations without allowing any further instructions
> > > -      to be executed.
> > > +      completed before performing a live migration.  In general, userspace should
> > > +      exercise extreme caution when invoking ioctls other than KVM_RUN prior to
> > > +      completing the original operation.
> >
> > Perhaps worth saying why? E.g. (as I understand it) that for these exits the
> > operation is only completed on the next KVM_RUN, and that KVM relies on state
> > left over from the exit (including parts of struct kvm_run such as exit_reason)
> > to do so, so any ioctl invoked in between might clobber that state?
> >
> > I see you intentionally avoided documenting the pre-fault case on its own, but
> > with the above stated I think a concrete example might be example here, like
> > e.g.:
> >
> > "For example, if you were to ... that would result in ... which would absolutely
> > ruin your day because ..."
> >
> > Kinda thing :)
>
> :)
>
> I'm not sure it would help, tbh. I think a reason or an example would
> have the effect Sean wanted to avoid [1], where a reader takes an
> ioctl that doesn't match it to be safe.

Ah fair enough, I missed the bit about purposeful fear-inducing vagueness :)

I guess the retort to my suggestion is that a user may think 'oh well I'm not
doing that so it's fine'.

Fine line to tread I guess!

>
> Cheers,
> /fuad
>
> [1] https://lore.kernel.org/all/av5CBjbeidUUWiLq@seanjc-mac.roam.internal/
>

--
Cheers, Lorenzo
