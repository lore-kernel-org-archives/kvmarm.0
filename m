Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446586;
	b=1IXKWd2z+BCIA/Dya2hw1ELupjBw9Nb9bYJRDLA4luZymftHIhwWYeIQ327UindjL9Hs
	 WqV9ew5epBs706pEjuWReQCRtT7XEJ1rOxywGu3s893rqY2owAL98ee/VjLCEYX/uRGZj
	 kHPsldJD5xFeu+E4xOcBJwt4tw8QD5gDrXedlh7tKvtDVWhF48EcNP+rCmkQvUjBL6SMw
	 eSvoIP68nu7wz47IdCe7DNrBZHHpu6sJI9klOYJXb7Ud7/w4KghtCcj6tAtUjryp4U829
	 6zCBLO1C7tVL/12puyLppxKPw3uNKY1Uox+o7J162tarfKOxsRRhFJQjj3gFrN28CWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446586;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dnrRfjLKmIHDzHFw2YMyKPd3bYE0BLJV4hjG0NzpuHY=;
	b=Jd6OFtQMPmUj2kCkK0IhAO4w7pgXveAzDelTzTmrmRwqfPz5/pS9YlUWsrwWAa6hJU8/
	 NMddgnss2SjVIsxNs0Z3K3rUEPinwBJcUVw61T6wU758V9H8e0EIn+AD7mAvlodoWN4Aq
	 ItR2ssAuqgLQwvwRENv9pk+tVbEa0UOFUcTEvpqXHJ1QDhwFHOuAV1kY7Alz/iSWCksJz
	 UH3ayA8Q32ER+Lrm7PE2iOhF+yP7J0ujh5KHOSevAP1XCvMYC/TP4Pu+2TGa7P+Nvt/+A
	 Q/JtA+aqsyTDNmy/xHAzVncEJ8h9QN/5hHlR5dSN8kfM5lOrD9sbkDXOfjp4+jLo2cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9x6wQRX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1615606A31E;
	Mon, 23 Nov 2026 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B9x6wQRX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A2F1F000C6;
	Mon, 23 Nov 2026 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446586;
	bh=dnrRfjLKmIHDzHFw2YMyKPd3bYE0BLJV4hjG0NzpuHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B9x6wQRXV+lRd06FkMrkTcZJeaS8e3jKOIyXDTANXZqBMOvrR7KOjDyWtCjEChBDL
	 j5Y71qINNgguMOorYNzL7fKWDS1xnps2HarzILPgiCJxVqW9l/EC7xCStdAaT/eej2
	 RJyu8K2qXQou6Nv7kib6MPEB7zCBTWIZYIEwOLADYEg6x/lWkemMCtYlnUVk+utNKl
	 LWINkzV/1Ome0GRNKk4Mwe/dZFz44LhqCnu7ys9jz8oLXgsulh3anRrU76m0FTriFc
	 32562AhcsRlcrH3xdfq4ALU+mZnwxHQP766Mmn+QFltMAR685VD564pFHboFGfb1qm
	 s/gtz/HsAkX0g==
Date: Mon, 23 Nov 2026 15:09:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Wei-Lin Chang <weilin.chang@arm.com>, Anup Patel <anup@brainfault.org>, 
	Atish Patra <atish.patra@linux.dev>, kvm-riscv@lists.infradead.org, Will Deacon <will@kernel.org>, 
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v3 2/3] KVM: Warn userspace against ioctls while an exit
 is pending
Message-ID: <awRKhCne0gG1gKZN@gremlin>
References: <20261123113435.1170711-1-fuad.tabba@linux.dev>
 <20261123113435.1170711-3-fuad.tabba@linux.dev>
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
In-Reply-To: <20261123113435.1170711-3-fuad.tabba@linux.dev>

On Mon, Nov 23, 2026 at 11:34:34AM +0000, Fuad Tabba wrote:
> KVM_PRE_FAULT_MEMORY sets run->exit_reason to KVM_EXIT_DIRTY_RING_FULL
> when it stops on a full dirty ring. If an MMIO exit is pending at that
> point, the next KVM_RUN on arm64 and riscv doesn't complete it. Rather
> than document that case alone, which could suggest that other ioctls
> are safe, warn against invoking any ioctl other than KVM_RUN before a
> pending exit is completed.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>

Very much agree with Sean's take here that we should instil sufficient fear in
users at doing silly things (also in general not only KVM :).

I wonder if we could add some specific examples or broad description of why it's
unwise for better effect, though? Comments below.

In general though:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  Documentation/virt/kvm/api.rst | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 89eb6be9bc6e3..980ef0cdc1c91 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6974,10 +6974,13 @@ to the byte array.
>
>        The pending state of the operation is not preserved in state which is
>        visible to userspace, thus userspace should ensure that the operation is
> -      completed before performing a live migration.  Userspace can re-enter the
> -      guest with an unmasked signal pending or with the immediate_exit field set
> -      to complete pending operations without allowing any further instructions
> -      to be executed.
> +      completed before performing a live migration.  In general, userspace should
> +      exercise extreme caution when invoking ioctls other than KVM_RUN prior to
> +      completing the original operation.

Perhaps worth saying why? E.g. (as I understand it) that for these exits the
operation is only completed on the next KVM_RUN, and that KVM relies on state
left over from the exit (including parts of struct kvm_run such as exit_reason)
to do so, so any ioctl invoked in between might clobber that state?

I see you intentionally avoided documenting the pre-fault case on its own, but
with the above stated I think a concrete example might be example here, like
e.g.:

"For example, if you were to ... that would result in ... which would absolutely
ruin your day because ..."

Kinda thing :)


> +
> +      Userspace can re-enter the guest with an unmasked signal pending or with
> +      the immediate_exit field set to complete pending operations without
> +      allowing any further instructions to be executed.
>
>  ::
>
> --
> 2.47.3
>
>

--
Cheers, Lorenzo
