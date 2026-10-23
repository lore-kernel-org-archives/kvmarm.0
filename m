Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.140
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792743462;
	b=OHsANJ9ky+kca9wmtChk8O0X39xW1g5xChYeT6i6ycwwaNb0aB5jvvQGCkj/3f5Un8D6
	 Rqbz4VmH0FDSQNoAwBC+rIJjEQHMuA4QoGkjkCFRrW3vcOuP3tPkiyt+IaaLA3E+YNT3H
	 YcOkzbsriRXRteDQ9u/yD64eUzkEGnil94TMi+A5ftEtHLwzREm9rlYScFokIEX8GdzWY
	 KjdpdgpzsLjQe8P9Plt5QQENv+3WQbwLjBH33khL5r5euFxiE93ywXGYG8JpdvaBP5Tox
	 jnrtjhkerOfO7l/T4gFXNMwGvcmfHaP2p7Zy+ADXKh2cB0BWwuGYTWR46/8jPRHx31A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792743462;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=qNsB+WdeCj5VypVcxsMZSCwyt6cdxmOolUo5Fs1wHvU=;
	b=F9j3xmlU8H3Iq0h4MFqpbkkD7PIqdiA9N1IxwhidsxAe6LVPAy3niqCIp5YwkucbQ7U7
	 GoCxTlMRw0RkNTG3LruA/dKY5BL8eaJ5CYdbr9jcSYPvmA354/dW8nxW2qgmJOatVq0Uv
	 /dYbzbTeYfe6V9rfuJAJdQmjQApdEmBKPuAlPX8eWFYqkHEKgBbf4LvfrcHG7/goNssh8
	 rZCpVPlyyIibWDUVDssY8ZNKM42zwFYDz73ksJECrfR9tPurQLld61tx9b0tmwvIMgY73
	 SqHr4MyrKO90bhiD3W6GfDkHa7f1FM6VWjsd65CeUx970/HcxTqEBU7RVeAOQCkzCrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HewK4t4R;
	arc=none smtp.remote-ip=91.218.175.140
Received: from mta0.migadu.com (out-140.mta0.migadu.com [91.218.175.140])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599A6606A31B
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 08:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 599A6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HewK4t4R
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3q8FYPFV6/mr5bsm1f2R+ib1owIqgidysonIiS2gMzA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792743459; v=1; x=1793348259;
 b=HewK4t4R2Bj/oFfl4TKhbcPUYvmqj8Ic166L1IxkSl5nADKqqR/ADLTkroCr/srWV6N2Fy0d
 bTIfhBgM0PDlrwYZWGGMYUO7wWiTC6Ig12VPWGhAKWZIRGZRLTpgnWSCQdarvsdaYLduDMY0hI7
 3yMIyMQn1gbysvSyt5N256rQ=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e45c14a784e98ea7;
	Fri, 23 Oct 2026 08:17:38 +0000
X-Mizu-Trace-ID: e45c14a784e98ea7
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso4102e87.1
        for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 01:17:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzRqdbslmMfQkM4BrjomgRGL3i94tGzzUrcr8O8O4XzG6ZMU6eW5H6DhPwQFdGZcYU84yxRDOw=@lists.linux.dev
X-Gm-Message-State: AFq9FYLuLBaxWCSewk4P6bl5tjH4jo8qnnkh1+zc+Nzp9zPjVxee4bE8
	gPfE3oiDw9eEZdvHIspHmN8JtV9LEWwXZviHf2xZ4JsrxfDdSnO981ziEyTGsprMzG4h2aBwcJe
	qePg8CYDfWq4jIZ0HqQ2buhw4TZLFrlYxwI8WeZ0h
X-Received: by 2002:a05:6512:1111:b0:5bf:aeea:6e42 with SMTP id
 2adb3069b0e04-5bfb06d38f2mr78643e87.8.1792743457929; Fri, 23 Oct 2026
 01:17:37 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261022-b4-vncr-mapping-test-v2-1-033e63ee055d@fujitsu.com>
In-Reply-To: <20261022-b4-vncr-mapping-test-v2-1-033e63ee055d@fujitsu.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 23 Oct 2026 09:17:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwoY0e6oaJoQg3-1Ns=RVPfdACAaVuJE-_DgLUHhMqg9A@mail.gmail.com>
X-Gm-Features: AclHuK_ZP2kPcYLceD_8xYePQ21UVh1ALRPCnQDdUQxEW_qnQ2BndoyxjgDJICM
Message-ID: <CA+EHjTwoY0e6oaJoQg3-1Ns=RVPfdACAaVuJE-_DgLUHhMqg9A@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: arm64: selftests: Test VNCR translation invalidation
To: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Itaru,

On Thu, 22 Oct 2026 09:11:18 +0100, Itaru Kitayama
<itaru.kitayama@fujitsu.com> wrote:
> Add a standalone KVM selftest that checks VNCR accesses after L1
> updates its stage-1 mapping and issues a TLBI.

Could you add a sentence on what this guards? KVM caches L1's
translation of VNCR_EL2 and has to drop it when L1 invalidates that
mapping, in kvm_handle_s1e2_tlbi().

[...]
> diff --git a/tools/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c b/tools/testing/selftests/kvm/arm64/nv_vncr_tlbi_test.c
[...]
> +static void handle_l2_hvc(struct ex_regs *regs)
[...]
> +       case 2:
> +               /* Check invalidation again, with the mapping reversed. */
> +               GUEST_ASSERT_EQ(regs->regs[0], WRITE_A);
> +               GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_a), WRITE_A_AGAIN);
> +               GUEST_ASSERT_EQ(READ_ONCE(*cfg.slot_b), WRITE_B);
> +
> +               GUEST_DONE();
> +       default:

Could you add a break here? GUEST_DONE() isn't noreturn, so this falls
through into default:.

[...]
> +int main(void)
[...]
> +               case UCALL_DONE:
> +                       pr_info("PASS: VNCR accesses followed A -> B -> A mappings; "
> +               "inactive backing slots remained unchanged\n");

Could you align the second line of the string under the first?

I ran it on QEMU with kvm-arm.mode=nested and it passes. With the VNCR
invalidation in kvm_handle_s1e2_tlbi() disabled, it fails at the round
1 check, so it catches the bug it's meant to.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>

With the issues above fixed:
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
