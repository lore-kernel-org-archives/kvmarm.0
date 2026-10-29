Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.40
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274130;
	b=dCcNECBuwDEHq49ldN+usoDh2KPUlj92yev8mZd0zxAPnlIm8Ja3liGpzKE45nLxTRrA
	 Llvm5Ppck+zwd1N0R8b4SIrQDj8n9sILPUGoudU/EJww2o39NYGtPegpDsjEqGUHTrE6+
	 xlHAGFFItjLzR2rhKtJXgrqb1hKddR+gHMBveFy48MmygTp5NMYN+t2TELOTZ+1NVPIhF
	 d+VDeO8vdDSCONCoAY/A6jSzkBm88hxocGpH0w1WMdK7uQYlQpehLpUS9IPgdOtwVWEfc
	 fPYLqEfV57eW0ruOstSEaMCmkVUAOUdOHdQpOp8ctZ6BMtIr+nbgswEmcdsTE9rPA3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274130;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=lNKnDSm6DWP7OhUxWQd4mOe7im/nMYs8Ki0YFs7PQN8=;
	b=d5GSgjlceVcHOGScjE0itmKK82ExLR1IVZmDe6bmmuot55litZ6D+o1Tf2+qmVqCetvL
	 /t8WlNa/RSxnb7WnXlW+40gc1RHb+1u96fDToyRtXrsEEP9oE8sTegJkGJZmATEX2QJBr
	 e90Eai5aTQ9E0AjJOcBHR4H8E8q0CoJNYwhFRovnwO6kYKhGspzh4IuWjfsAjRc3GCWvj
	 puP6qnbHbdAGrf98DPABcq/FM40UnOHwy7UAJHkxnsakAq86uDHfPewyaLWAderS7rlft
	 /4Ja5ZmjjQ91/19usXFEKHTIwhmRAs9uEgm/D0bNLNAwtlm66UCGCZTTHe6AgU9mGkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kv3o1VY8;
	arc=none smtp.remote-ip=91.218.175.40
Received: from mta0.migadu.com (out-40.mta0.migadu.com [91.218.175.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6771606A31D
	for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 11:42:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6771606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kv3o1VY8
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=PnHgOuaW7I0Mn/MofV12U5YliQliS5wKeUNRMOs0Mn4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793274127; v=1; x=1793878927;
 b=kv3o1VY8bYtasTGaWRbawLuIOTzogz4KAPJVzsk+vMYzSbCe7tyGoprqXBc8NM4LG+TkFcod
 Em7Wcf5kGPGSJQ1Ijgny+emjIFZZsOTmt9/DiQEWiCoQV9e1obES+HvXqv7ILbSIfUSu7gZ7GfY
 OthCgV/LTOcsiM27f4TmUUqc=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5a8a3ed942ed644a;
	Thu, 29 Oct 2026 11:42:07 +0000
X-Mizu-Trace-ID: 5a8a3ed942ed644a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5bcbb378fc9so7939e87.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Oct 2026 04:42:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwhNcJzLPNxWwclu2idJCw6FqKG+NwQQhBB8KF6vKnFXZpV/822A+nBytkLXsS8tUTPnX7Q3qw=@lists.linux.dev
X-Gm-Message-State: AFq9FYJsq4NJCRwJ5D+YGkWD4jXdnzw4pXtfWEfdRFbEz6QhwZGJvv8G
	JIfNOVOFkJddhzBEh8xAMv8tbLBbx5hgH0yBEkDdQq/0zIcUZBMZhoDLNyRHo65raM641/EeTma
	R6TF7MM7ibpmSb8X5xcXeBkcWdSmO5i5jTTLakUK9
X-Received: by 2002:a05:6512:1052:b0:5bf:b994:6598 with SMTP id
 2adb3069b0e04-5bfd142a3a5mr145865e87.6.1793274118982; Thu, 29 Oct 2026
 04:41:58 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261029090522.64662-1-oupton@kernel.org> <CA+EHjTz-kXVbzcjtMte8B26f0Undr+kWjF2-d0B8TLT8n03hJg@mail.gmail.com>
 <86ld7gydqp.wl-maz@kernel.org>
In-Reply-To: <86ld7gydqp.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 29 Oct 2026 11:41:22 +0000
X-Gmail-Original-Message-ID: <CA+EHjTw0EjMHKOH8s0F6PZRR7WkmRJJrMrqTzpYoP9gm5n_9Gg@mail.gmail.com>
X-Gm-Features: AclHuK_Z0kHPbYh0i1HryGJaOSIwXE6_zjBe1WXl1ax6QBriG_I6vIJcW96TN10
Message-ID: <CA+EHjTw0EjMHKOH8s0F6PZRR7WkmRJJrMrqTzpYoP9gm5n_9Gg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Respect HA when computing translated TCR
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 29 Oct 2026 10:58:54 +0000, Marc Zyngier <maz@kernel.org> wrote:
[...]
> That's a good point. However, my reading of the ARM ARM indicates that
> as long as S2 shareability is Inner-Shareable, the resulting
> shareability is Inner-Shareable (see R_ZNLRJ), so we're actually safe.
> This should be fixed though.

If my reading is correct, I don't think R_ZNLRJ is enough here.
AArch64_S1Translate() (J1.2.4.57 in M.d) checks the walk attributes
before it translates the update through stage 2:

    // Either the access flag was clear or AP[2]/nDirty was set
    if new_desc != descriptor then
        if (!IsWBShareable(descipaddr.memattrs) &&
            ConstrainUnpredictableBool(
                Unpredictable_Unsupported_Atomic_HW_Update)) then
            fault.statuscode = Fault_UnsupportedAtomicHWUpdate;
            return (fault, ARBITRARY : AddressDescriptor);
        end;
        ...
        if regime == Regime_EL10 && EL2Enabled() then
            ...
            (s2fault, descpaddr) = AArch64_S2Translate(fault,
                    descipaddr, s1aarch64, s2aligned, descaccess);

descipaddr is what AArch64_S1Walk() returns, and it holds the stage 1
walk attributes (walkaddress.memattrs = walkstate.memattrs, with SH0
from TCR_EL1), never combined with stage 2. R_VSXXT also covers an
update "not supported in the stage 1 translation due to the defined
memory type": that one is a stage 1 abort, taken to EL1.

But it's not like the ARM ARM is an easy read :P

Cheers,
/fuad
