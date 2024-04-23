Received: from fout2-smtp.messagingengine.com (fout2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2019182C60
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 12:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713875853; cv=none; b=fox1nT29Cq2QB69j9KnDs1Brh7IDa2F414RzDGEm3FwApwew8B7f1pl8shYGODH6MeC0mymWToIr+KZjM/Lfiihx+rQC12ftruDKFBH4qitHc6/jbzOh/k1ge5fsH1eNxLngkC9WhqjD+wHcbS7f2cx+9PScxsppDWPYy8SyRnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713875853; c=relaxed/simple;
	bh=xkhH/UA3UyznhkBWp5482Fpqj595D+O/QTK8iwMJ5JQ=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=A73Q1crjIi8bevVsDiTQxUTmiAynqrtdaMoiETr36OX9FTqRfNjkbIjgpxzUveDO6tNi6BWNKyyYgxV9/S5VqhHgssUfKd2ae1+WGMG/9nO11vOahwBmHG65chhNX8E18gVyNeZBAf9yIHZ+9+j5OcvIJkIibKJ/NsWNTNx00zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=hyc3yZHL; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GbO437nK; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="hyc3yZHL";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GbO437nK"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfout.nyi.internal (Postfix) with ESMTP id 3647913800F3;
	Tue, 23 Apr 2024 08:37:30 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Tue, 23 Apr 2024 08:37:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1713875850; x=1713962250; bh=dYBIiyebXU
	zVTqIXzZSOLioEANbfpV6DnHCY6//IT2M=; b=hyc3yZHLHh4eb43VLtUEQa5WaX
	gD4p8o8tlQklQXhzMsL++yHQSG2fQ8sLndSX9tfKIUTCE09SuEzUWew7LS6A98ax
	2MOTNZ4EWjXqgub4PJjPZCYFdomzNhPq722R8Xqf0Aq55KujJAZ9wTqVmQm7rQb0
	omit4LgdA92iyfn2UPuidl6V3lPbu0Q1fGza7zpUONP6O03rsGrh//SmcMD5aZBx
	+xF0nb3mS7JPIXWGhi4++o9UJhmNesigchraDx1ORd4gtP8JMvsxEhi8ecdNJTNB
	PlDytdW2cr7WH15t6KRpQH6hFdI4Di52TUKJqq3+icMeknx+swnXdZi2OWog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1713875850; x=1713962250; bh=dYBIiyebXUzVTqIXzZSOLioEANbf
	pV6DnHCY6//IT2M=; b=GbO437nKuXNwVDu2wMM+L7dEkU/CXPEMsw0jKv21D2vK
	UzS2FXuOFKLFoW4RqXANxPZK74uL8qp0xzXHwYr9NLoZ0Lpy4PeU+bvoik1lnFpj
	qCQwIFTyZ89rkrNe3sKoUSp9gnxa507/w/deVDnGS5VlEhQsFLpo8B9HFcpJu1cy
	ntR9R9Jmr85swylfRbs0Bd9s4qatckAMoeyIM8HeWCKMa6jwmCqwpC52IwmUToHl
	nzGiuY1oTSqDLbUgmBy2AIUn362+V+bSJSWo1oK8Oqn1rrbOUgH12FdsgP/shTi/
	NyM93gV8Tfqw0RRQ7At2vCDmuCwXhA3/hY4FSDNgmQ==
X-ME-Sender: <xms:iasnZpbkNbQlHWxCaGzQI7Q4lAU0BoSzxxvp5nI_k4fw-ED_EIjTqw>
    <xme:iasnZgY0jzxeUb3fY28B_e_sRNJ6OlCQKQ8oeG6oVqECKgwrZ0P9VHhAhN7ceyiBO
    Q7JxHTWsh52S8-Uw5Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrudeluddgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:iasnZr_inpIiRbjmPJ3azVLfBqRF9yWi2StlB5X4kL5gsr8hAjwF8w>
    <xmx:iasnZnqRVRxeOSaRGrClCoaGfSD1ueWn-7LQbke2_ZiQlQavPAL_Fg>
    <xmx:iasnZkpR3hUPMG2BMLIfIcM1giLqO_M0Lf5UWNCF65sj0xGwdH0e0A>
    <xmx:iasnZtS0z6kWoeD6MC72qtgo-12c5wK6lMPYIOVNhMC8Sp-NBTm4LQ>
    <xmx:iqsnZqiOObvLbIT5b3lzlit7se2ObtP9cDXyL3N5AU3Kx_btj64tcclN>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id A264BB6008D; Tue, 23 Apr 2024 08:37:29 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-386-g4cb8e397f9-fm-20240415.001-g4cb8e397
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <a495bc0d-ff35-46fc-842b-368ce59a88c1@app.fastmail.com>
In-Reply-To: <87o7a0tha6.wl-maz@kernel.org>
References: <20240422224849.2238222-1-maz@kernel.org>
 <fa6c31c5-9334-4248-aa89-a0951f1b13c6@app.fastmail.com>
 <0b970cf5-a880-469c-93ab-9a268ee4ea2b@quicinc.com>
 <87o7a0tha6.wl-maz@kernel.org>
Date: Tue, 23 Apr 2024 14:37:09 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Marc Zyngier" <maz@kernel.org>, "Maria Yu" <quic_aiquny@quicinc.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 "James Morse" <james.morse@arm.com>,
 "Suzuki K Poulose" <suzuki.poulose@arm.com>,
 "Oliver Upton" <oliver.upton@linux.dev>, "Zenghui Yu" <yuzenghui@huawei.com>,
 "Mark Rutland" <mark.rutland@arm.com>, "Joey Gouly" <joey.gouly@arm.com>,
 "Will Deacon" <will@kernel.org>,
 "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "Linaro Kernel Functional Testing" <lkft@linaro.org>
Subject: Re: [PATCH] KVM: arm64: nv: Work around lack of pauth support in old
 toolchains
Content-Type: text/plain

On Tue, Apr 23, 2024, at 14:06, Marc Zyngier wrote:
> On Tue, 23 Apr 2024 13:00:55 +0100,
> "Aiqun Yu (Maria)" <quic_aiquny@quicinc.com> wrote:
>> On 4/23/2024 4:24 PM, Arnd Bergmann wrote:
>> > On Tue, Apr 23, 2024, at 00:48, Marc Zyngier wrote:
>> >> We still support GCC 8.x, and it appears that this toolchain
>> >> does not understand "pauth" as a valid architectural extension.
>> >> After all, it's only been 8 years since ARMv8.3 was released...
>> > 
>> > Just to clarify: I'm fairly sure that all supported toolchains
>> > support ARMv8.3 and PACGA, the problem with ".arch_extension pauth\n"
>> > seems to be that it was retroactively made an optional
>> > feature for earlier architecture versions a few years after
>> > ARMv8.3, so most binutils versions we support understand
>> > pacga as an armv8.3 feature but reject the pauth name for the
>> > extension.
>> Kind of agree with Arnd here.
>> Shall the fix just remove the ".arch_extension pauth"?
>> 
>> I've tried gcc 7 failed with the pauth name for the extension.
>> After I remove the ".arch_extension pauth" and use "pacga" instruction
>> directly pass the gcc 7 compilation.

It really depends on the binutils version, not gcc of course.

> And breaks with LLVM:
>
>   CC      arch/arm64/kvm/pauth.o
> arch/arm64/kvm/pauth.c:40:9: error: instruction requires: pauth
>                      "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
>                       ^
> <inline asm>:2:1: note: instantiated into assembly here
> pacga x19, x1, x9
> ^

It works when building with LLVM_IAS=0, which we obviously don't
want to mandate here. The variant below works for both clang+ias
(including all still supported versions) and gcc+binutils, but at
that point it gets obscure enough that your .inst version is easier
to understand.

    Arnd

--- a/arch/arm64/kvm/pauth.c
+++ b/arch/arm64/kvm/pauth.c
@@ -36,7 +36,12 @@ static u64 compute_pac(struct kvm_vcpu *vcpu, u64 ptr,
        __ptrauth_key_install_nosync(APGA, ikey);
        isb();
 
-       asm volatile(ARM64_ASM_PREAMBLE ".arch_extension pauth\n"
+       asm volatile(ARM64_ASM_PREAMBLE
+#ifdef CONFIG_AS_IS_LLVM
+                    ".arch_extension pauth\n"
+#else
+                    ".arch armv8.3-a\n"
+#endif
                     "pacga %0, %1, %2" : "=r" (pac) : "r" (ptr), "r" (mod));
        isb();
 
