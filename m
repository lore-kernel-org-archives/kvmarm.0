Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793002907;
	b=FFr4VXDdXstax6N0zVBpeovUEpIBeagYFBijv/UM+JXAoIh3FTKm9NRvrTSBP+v9z2X7
	 1cOFm3WAW/WPbdZ62xAOTDKe3Eguz6LcYXNbBpWoWRWI1XPHF+YQxTIXsnqQE9EWwBI5s
	 afp1A87rbghnlmO3+CwLczSPmUpynstUh5zH/9HQVj3087jxfjjfZGA4wq8UgBNPeykzd
	 E/+DBU2/CYMIcJiMT9CwKgblemKydQj1B/yg30dwIVYYquQoCkDEZG8YHcw4sslj2Zi4g
	 rH6/NwuDhVqwxJmJSfe9lFrkZFF8sp0mbkThY9gMq3E9WBkNisuF8lev5yN9AG1bvUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793002907;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=HeN8sKTlUL/VwaqkACE76c/cgf/RcKGyONBxScYlrEc=;
	b=a57x12hZCPx3N04fJUxoigkzWUoect/tpGndqXRTAvKUTJU6yOuJBznxgfBKcuzl36qT
	 KTarLUmF2XECTJ/3aRsCvmiA4Q2hyv8lI8YH4hIbHcgwGf/a20D6OWKa7tyUUA1gRFUm/
	 68SHEZ7KzkKEjMYHQYkqjlhU35NrS5oz2uv5pUO8v2BuO/xWISB00peXSNYxgy3W7bQFQ
	 q0T2tGiJ/LKVsVxEew7W/VJEGcACw3YAIIPTIbDdR42r8eLqAfpR2t54j+FgeCSF1l23C
	 /10OMFelmnZbaejWSH1TrYQQAQF7zqBIDStJf11Iuox7nk3Vg40aGyNlFsq39Ncr3PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="UQ/DM8Yx";
	arc=none smtp.remote-ip=95.215.58.108
Received: from mta1.migadu.com (out-108.mta1.migadu.com [95.215.58.108])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC83A606A31B
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 08:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC83A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UQ/DM8Yx
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=HeN8sKTlUL/VwaqkACE76c/cgf/RcKGyONBxScYlrEc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793002904; v=1; x=1793607704;
 b=UQ/DM8Yxh+CE1VqZrT8hgxcAFzevlYys88YQQqzCEG4WLep6seWzB6VSl/ax7ATSgjBLan4Q
 6S2T2KbWv0U/Sjo3XAi1yGpwHmUOxQ1KgWoZGq83/vThAyL/4KUegeAzhZuzVY0fWdkkEZpepte
 uqdPvS9mfAztQI3UCJBZCCf8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5d26ab0b4a6b1bcc;
	Mon, 26 Oct 2026 08:21:44 +0000
X-Mizu-Trace-ID: 5d26ab0b4a6b1bcc
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5be4a7b9e6fso6288e87.1
        for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 01:21:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxUBqWsJNYhp4LP36DpeSvrsowMtK3fiKfUmEUxAn4cazUyaqFSJsk3TNcaYCY2u/YlAYF2kWI=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ0hQQJ/A9y/R5IBB+7iAbhOHq3SHLYvHywaed3QVuOVesVXU6p
	FsHF/tKBh6lbEJ1ek8GvpjxF+dAP4bAY3cLwl/gPYZWwzxdE6A4coOX8APQnFx1zOlmBJzFJPqn
	LNeDntUa5im5lryU01fvMLwUAsdi7SGBieJDVAZa3
X-Received: by 2002:a05:6512:3091:b0:5be:4d73:e44d with SMTP id
 2adb3069b0e04-5bfb79db1f6mr139727e87.5.1793002898251; Mon, 26 Oct 2026
 01:21:38 -0700 (PDT)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261026-b4-vncr-mapping-test-v3-1-7c094a00d46e@fujitsu.com>
In-Reply-To: <20261026-b4-vncr-mapping-test-v3-1-7c094a00d46e@fujitsu.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 26 Oct 2026 08:21:02 +0000
X-Gmail-Original-Message-ID: <CA+EHjTy=bU1ygvgYiwKiWpxP4XTY_QEmkMgW=Bxd1pxyFZ0qdA@mail.gmail.com>
X-Gm-Features: AclHuK9mNQcdy23LyjVrKUw6ZiFaEhEa1RjPtCWEqLpOPj2wxuYrSqZs8yklhYY
Message-ID: <CA+EHjTy=bU1ygvgYiwKiWpxP4XTY_QEmkMgW=Bxd1pxyFZ0qdA@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: arm64: selftests: Test VNCR translation invalidation
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

On Mon, 26 Oct 2026 03:10:10 +0000, Itaru Kitayama
<itaru.kitayama@fujitsu.com> wrote:
[...]

These are from v2, and I didn't retest v3 since it only makes the
changes I asked for. In cases like this, feel free to keep my tags on
the respin.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
