Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793635964;
	b=CAMXQUo89VzSnYPr9ih7U0w85JP19RwZFVEN51MB/No2m46hcLbvVFN3Yr1PhcuUuFU5
	 7vwvzqjfbs7U742DxT8dyo9ps04HZDs7ppmJywBTV9ldUTpGGkTbpXQIaM9YBNnvSv82x
	 SYSp1Hgbf3llJDu8idjrU3tkwy0CI91yiB2c8DaY2w4s2/XwHuaUvqNtwHMQcHdPsz4nA
	 iVVhqdG8nlRWDp+XEB2vGa4zh0w9NQvBL+2qxb16WmKzqIRXIZ4KoMWwd3102N4WElzs8
	 Oyqty+ikkMTXrUqMHu83JrUzOqQeGtzTj5FacKN0uFrvth3FBBrZQgM97pjl5bBgYzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793635964;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=Eo8yP9CSL6fw8R43nEuGtMZv/VD/kgNj4KIMa1kxKis=;
	b=NAvwvs4MnYkaDE13mfjf1bD1TP1TNzHvWxpiaXZt9xVSNSi7L3BMI6WYqIq1LZVnENUb
	 6a9ptknwQVVxNCaFH2+FRi6ZH8BlOA8BU0/uV6dGU7w9Wa3uM+OekSNY4DV0QIFGXD2hh
	 wKYNSuephdXh7dTtkt5ltvjxY+TPgKc49/fa3woRVU9mkbtvwJHzaDjaAuC5HwLwl7zFT
	 re206cuPHPv511vP7s0UBq12y7fxPiYOOcRk4zPnaxXSoihLOYMZW8EbbcX0C7PVIjPGV
	 F0G6o67d9151qzSKk9Eox0KwyUwQCkmNRO8Iho6zxbMMF4iB0JodsjBWl9FhbgnEBsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AToYC0li;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A6A606A90C
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AToYC0li
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717881F00A16;
	Mon,  2 Nov 2026 16:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793635964;
	bh=Eo8yP9CSL6fw8R43nEuGtMZv/VD/kgNj4KIMa1kxKis=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=AToYC0lieS4WH+qEKwrI2EJ71TXdgrpyxmLUj6PbCNQhGZ8+4i0DPy8RlW0BlbdCI
	 sY+GjR+J9jA03Q2txHHV+Al/sf4voalGzkzS9OQDsHdoUi7aHhTMf3MtHZhZyhEI+L
	 A9DkRAhnpf/5g6ZcgEKo94+MGzSfYGAZSxDfqYD+/Hpe9iKN+aDhIxkbv2gKaehPba
	 rCBGoe8UsiN8xkZ3Ejg17g5fW95HULon/jVMRfBNgMalrSunpCSjDeL7oyCrP9Xwps
	 JQl0iWaEP3A/3dZeMPU7O8cFnIGDqNxLc/IMv4mWdZCm58hpXGJao1By1imZNv+FiD
	 6gMUvQ7wS/2DA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id B582B198003A;
	Mon,  2 Nov 2026 11:12:41 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 02 Nov 2026 11:12:41 -0500
X-ME-Sender: <xms:d7boau4GEVq2dDqp84qlY1HQ-SlrPx6qvrRq388XuU-qOvRcWVD5gw>
    <xme:d7boaiubcEiIUW-FyvPP5VrH9F4Cv_q_se0-I7ZaeRtKKQ0OC7lqHV8Ytjhz00Zzx
    YL0fTEb5T2MFqzr13xTvfoQe9Ye0q63EH57c__S8QqWRJfeOr9o95s>
X-ME-Proxy-Cause: dmFkZTGJsUswHNgg1IGdHToMXw9N6Gez+gackLd4HLz/4Nuo00/0XFK8CkxG13I7ioNyBc
    nDBBorVxL1kzpl0PoYwNm0iMiflIpq/70DkAfSySqYdWSQwqTSHHSCcIhy74Dn87OTMtMY
    CthPehOyjaKbLho9md+3hQQV0cloAk7jrZSZ7o3KHhqm5PMz14J9+DmYD07dvZDHLnwWOp
    bUNC16gH6HnMW6D+tJ4ine+ZO835ooBnay9Snpl/XYhSdqNV79LLVQGxeUy1ODvxMkJscS
    G1c6SXp0gzwuK5bYJcHh3UW/7JTNjSlCxTGfT96gu+BeF5c4CxT/RhU9MyQCyGv5+NFqB4
    KNJWOTAbvn1uyeMUQKsWudXPoU9eeYmLNhG/84L+ed0H/ksd0/N99+k71By8aCajjTQKy7
    Xj+pFZhBuNEL+j2jJF3OBVFDzhECCxALNIUWMZZZyAYro4rOW/P0te5Hh6vcg33+u4PJ/C
    XouGjxUhnb+D4/UhQNr/yjq4C5ojQHzkzrhGWet2361DmISuCbKPH5aqm4sN9uN622BIWX
    09PD76r+GKjAVS/bP54doEoGB3dydU7MrWJtam2imAs2bYg8gV0a3/AYUlpEBOpSDjuift
    KKashaUjaGLOxbWlNQiRP7fNNqB6EgExcXUwZAH4x6SsHYChnnjWdj1BXx0w
X-ME-Proxy: <xmx:ebboamjBTGUkbEbxDHGTSKs0m3JgmaK0G-dGOMXNx5MsKFjJavfbBg>
    <xmx:ebboai00g1BIg48j0OMpzESO9grHH6pkq1623htVd2n2MNcghpUxcA>
    <xmx:ebboapfeihBQdu2kDqvxccP1sWw9nOwXtWcfj_FpXwCvJD6VZdYlDg>
    <xmx:ebboaoyt_ibuWyY3dETVC8ZAP_qDjttqqVQpXKCAMrIzrMWsxiXXfA>
    <xmx:ebboahxD9hVAhRC8InX78SdY2p9pSFE3N9UAUUn4Z87qpxAk6o874Xij>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5936DF80093; Mon,  2 Nov 2026 11:12:39 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Mon, 02 Nov 2026 17:12:19 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Fuad Tabba" <fuad.tabba@linux.dev>, "Will Deacon" <will@kernel.org>
Cc: "Ard Biesheuvel" <ardb+git@google.com>, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, "Marc Zyngier" <maz@kernel.org>,
 "Oliver Upton" <oupton@kernel.org>, "Joey Gouly" <joey.gouly@arm.com>,
 "Steffen Eiden" <seiden@linux.ibm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Zenghui Yu" <yuzenghui@huawei.com>
Message-Id: <f226b1c1-baee-4bd3-83cd-13b9fc6996df@app.fastmail.com>
In-Reply-To: 
 <CA+EHjTxVPyY70Dm+BiwgQQNwx1cJpEKvJBJGZWPCKLx2M8X2FA@mail.gmail.com>
References: <20261102094748.2638468-2-ardb+git@google.com>
 <auiXMN5td-2QlDkd@willie-the-truck>
 <CA+EHjTxVPyY70Dm+BiwgQQNwx1cJpEKvJBJGZWPCKLx2M8X2FA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't livelock when AT can't resolve a fault IPA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 2 Nov 2026, at 16:57, Fuad Tabba wrote:
> Hi Will,
>
> On Mon, 02 Nov 2026 14:17:10 +0000, Will Deacon <will@kernel.org> wrote:
>> On Mon, Nov 02, 2026 at 02:09:25PM +0000, Marc Zyngier wrote:
>> [...]
>> > Alternatively, VMALLE1 or even VAE1 should be enough to get rid of the
>> > S1 TLB.
>>
>> Ah, sorry, VMALLE1 is what I meant to ask about. I basically haven't
>> understood the need to invalidate the stage-2.
>
> The guest's walk can also go through a stage-2 entry for its
> page-table page, cached before the aging cleared that page's AF, and
> nothing requires the AT to use that entry:
>
> R_NPZWX: When an address translation instruction is executed, it is
> IMPLEMENTATION DEFINED whether the result can be returned from a TLB,
> or a translation table walk occurs.
>
> So if my reading is correct, on a CPU whose AT walks memory instead,
> the AT keeps failing while the guest's walk goes through the stale
> entry, and the guest takes the same permission fault again. VMALLE1
> and VAE1 only cover stage 1, so they'd leave that loop in place.
>

This matches my findings on the Apple M2: TLB invalidation at stage 1
only (using VAAE1 on the FAR) does not solve the issue.
