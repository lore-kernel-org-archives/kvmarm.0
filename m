Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793791945;
	b=p9KBbps64yHkPqZVzMNTwiQSBO41+c0aAwEjKNT/FGumtksU/ORB5jp0r+fEEr8X+o4o
	 6/4b3xcfqHpx2+G5KRT+5tB16FO/si3U0+yhBh3R4OtvjEL/dfOTr+d7RpHcBzm6iKlo5
	 PZEYp0l4yGDlKacsEUnWLsxcayWIK7clueguw5PMf3UnoJ8WiOUGk9tqc+vx84U+MxHoE
	 bZXM+IH4Gga2fKMhw33y4O6vtTZlO8wRpXWg9MVJTz23ArQ3LvSSirELx4rqshLSekfZm
	 AU1I+qE6Kx+ZPVdrSAtyy/7gn/txtmjMyco7fWfAwMPo+ICWmQXU5YqxjBlrgTDS78w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793791945;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:
	 References:MIME-Version:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type;
	bh=Sn3eSe67w3OleW5NGD87sSVusifSp8lGeY/kfZic8AY=;
	b=kMHNx0uDPSGZVP1b1AtUjO/qlerJ2+NIgtvVL3amT68XK9ntMnV5o2AXKgBoohL9RY38
	 anKhkxFHeuFZrkY6rkarZHNbHWnjtXMw+NqyK5t7mmb1ZEIT1goXEEd0G4+WlixFSikNh
	 oL3qh9WRFnrpc7OoKdM4mQ36rSKO9hTGb6LUyEgQnxFsaB6o5KoaaAvZS8k98nIhM89eU
	 PCe5WJ6n7WD9knDs3O3IREoAQqUTClVvQ74Rcq+QnAJPZ9XUq+RN3bobwzpA0niyn2Afh
	 uKSPKudm1TqEcFtXRx70b5qWIYSjXhrg+hWyUJuqNuSgSGFxzkS8KBUtR6vPbYCJEvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVXAfMn2;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B8606A338
	for <kvmarm@lists.linux.dev>; Wed,  4 Nov 2026 11:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 672B8606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XVXAfMn2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793791943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sn3eSe67w3OleW5NGD87sSVusifSp8lGeY/kfZic8AY=;
	b=XVXAfMn2yz4salNeCb3d0I+K16cZTF0zY8+XEv+FWwMvK3j3P+tTBXebYEiJ4spcWwtKH9
	6CXpwaAVcCJ+UDd/kif6xL/riGsF8HbbYidP2QqCo61XbsYnqnRSc7EF5F+3RN1Vit35Th
	jxoqlwAxDjbwIkFSv+L18tIKgWS4GRQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-VlrWJGkzNu2HT_DmPjqplQ-1; Wed, 04 Nov 2026 06:32:20 -0500
X-MC-Unique: VlrWJGkzNu2HT_DmPjqplQ-1
X-Mimecast-MFC-AGG-ID: VlrWJGkzNu2HT_DmPjqplQ_1793791939
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4ae2756fa7aso4640835e9.0
        for <kvmarm@lists.linux.dev>; Wed, 04 Nov 2026 03:32:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793791939; x=1794396739;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sn3eSe67w3OleW5NGD87sSVusifSp8lGeY/kfZic8AY=;
        b=KAEnf90K3KnorSM8njXKftkGuS4sOzljAWYblLEnN9PszL+MQD6E4BuUizZQjhQz3Z
         v8s8zTf1WS8fN3qvBU6lDqR4GTA15JR6V3ReAT4pf02iOhxr3QxfjsMr0jIb6tdfTv0a
         M6ki9Ft1YOZ/JbE4ImL7HCqMQIhZy/K7E1nAuFj40pbGFqF/Ze0P1z2+Ya5mO7X6bGtV
         Dr5onhHnAW5o2dLyYwp99KE2VJJIPVtCq9ErRmTWO2l0nS00P7WM6zDuiD4JL/NuCav3
         akm/cFES7nlvdWZJaliVe7ikJxAHAA/ftvdXRiRY+IqYqtmcPQgI99szwqKzwB/hcFZ6
         k3gg==
X-Forwarded-Encrypted: i=1; AKwUvBzMe2nQvEPfy00R7L2b3QmSZ4w4VcCb5igV9/kkXIf9y8AQST/rGvpy3wGCtcadsCyqys/Ci80=@lists.linux.dev
X-Gm-Message-State: APuU4Z+USTqDJNvUldPnjq35od0xl/fzT44p+j9sLU4o+nx1UslXe5ul
	zHISgM0FeWiYUhK5j2QYWoA3xElDf+024fmbIVp5GxLeEuLKw8zPhiLw6TrCJy8y7Rbxd1KEH7K
	yki6P9tU3k2O/d9o1vfQpqdmRDfR17JwX5iPVDPQcdcQFLjOpag+SZKFFoxflZBu3CA==
X-Gm-Gg: AYBFou1WOC4iG1scKv1JbHluzelkXbVNAeaw66dodMJ29O/rVSpkN7jI4wGhQY1jrq/
	yZtx+yiy2wpYzH16z8NI/y6VOHPW+BEHby4CHyBZcLvz89E3qckAbDzo3itV9OGPzl9k+5OEslu
	t0aRsWGZN/VBKoU407SnYTYYjHDog86VMD+UZRj5Lc4hd0WsCCvpJWRVf8mPVlQwGbd3qA6Vscp
	6230xyy2ejxpx6EXknIiTNtFO00l4KV10nWsyQxYcAIO2FFP7+uP/XU/6wsbc8+EPzkDUIFAKCA
	SS4UFegi6P13cd3l27x2Jk2I3kV4ciaAARpKrGNyFBFazTmcQw5cap4E70ien4vO4JZhxec0ewK
	KgLo9uWpzIj7JZ87Le/S0Q6vmhueLrLIHzsvTkyg5+GxD0AJF6uN/co/bRUR9fieHGGVj8JODjX
	h9Ybltll3XWmDTO9GSnToQ6RHQC5QOG5iU8XBdJA==
X-Received: by 2002:a05:600c:4e02:b0:4a3:59c9:a758 with SMTP id 5b1f17b1804b1-4ac19705e02mr339637895e9.32.1793791939098;
        Wed, 04 Nov 2026 03:32:19 -0800 (PST)
X-Received: by 2002:a05:600c:4e02:b0:4a3:59c9:a758 with SMTP id 5b1f17b1804b1-4ac19705e02mr339637545e9.32.1793791938760;
        Wed, 04 Nov 2026 03:32:18 -0800 (PST)
Received: from seott-rh (p200300f6af1574019b2c5947d8ec139e.dip0.t-ipconnect.de. [2003:f6:af15:7401:9b2c:5947:d8ec:139e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b4527fed5bsm60945795e9.3.2026.11.04.03.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:32:18 -0800 (PST)
Date: Wed, 4 Nov 2026 12:32:17 +0100 (CET)
From: Sebastian Ott <seott@redhat.com>
To: Mark Brown <broonie@kernel.org>
cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
    Suzuki K Poulose <suzuki.poulose@arm.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
    Oliver Upton <oupton@kernel.org>, Ben Horgan <ben.horgan@arm.com>, 
    linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
    kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-kernel@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v9 1/3] KVM: selftests: arm64: Report set_id_reg reads
 of test registers as tests
In-Reply-To: <20261103-kvm-arm64-set-id-regs-aarch64-v9-1-ab32bc79fa9c@kernel.org>
Message-ID: <4df3cceb-0d07-d787-b5b6-0a28433116f3@redhat.com>
References: <20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org> <20261103-kvm-arm64-set-id-regs-aarch64-v9-1-ab32bc79fa9c@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IoobIcICIqvlDrP3_-KuRAmE9xTkItYnHo5m-yenz6g_1793791939
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 3 Nov 2026, Mark Brown wrote:
> Currently when we run guest code to validate that the values we wrote to
> the registers are seen by the guest we assert that these values match using
> a KVM selftests level assert, resulting in unclear diagnostics if the test
> fails. Replace this assert with reporting a kselftest test per register.
>
> In order to support getting the names of the registers we repaint the array
> of ID_ registers to store the names and open code the rest.
>
> Reviewed-by: Ben Horgan <ben.horgan@arm.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Mark Brown <broonie@kernel.org>
[...]
> @@ -684,11 +719,20 @@ static void test_guest_reg_read(struct kvm_vcpu *vcpu)
> 			REPORT_GUEST_ASSERT(uc);
> 			break;
> 		case UCALL_SYNC:
> -			val = test_reg_vals[encoding_to_range_idx(uc.args[2])];
> -			val = reset_mutable_bits(uc.args[2], val);
> +			expected_val = test_reg_vals[encoding_to_range_idx(uc.args[2])];
> +			expected_val = reset_mutable_bits(uc.args[2], expected_val);
>
> 			/* Make sure the written values are seen by guest */
> -			TEST_ASSERT_EQ(val, reset_mutable_bits(uc.args[2], uc.args[3]));
> +			reg_id = uc.args[2];
                         ^
Minor nit: this could be moved above and be used in 3 more places.

> +			guest_val = reset_mutable_bits(uc.args[2], uc.args[3]);
> +
> +			match = expected_val == guest_val;
> +			if (!match)
> +				ksft_print_msg("%lx != %lx\n",
> +					       expected_val, guest_val);
> +			ksft_test_result(match,
> +					 "%s value seen in guest\n",
> +					 get_reg_name(reg_id));
> 			break;
> 		case UCALL_DONE:
> 			done = true;

