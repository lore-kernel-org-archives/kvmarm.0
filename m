Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEB6C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 17 May 2022 17:27:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 255654B2B0;
	Tue, 17 May 2022 13:27:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ED0Fd9r0or-R; Tue, 17 May 2022 13:27:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E84D24B2BC;
	Tue, 17 May 2022 13:27:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 284E04B2BC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 13:27:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WdW7P0anVFQY for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 May 2022 13:27:43 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1AEB4B2B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 13:27:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1652808463;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=KKq680AnszBszJpoGIG9251C41AK5g6xGWKr2ftGslI=;
 b=QpMRh8oezk6dysBJHOvRcDsO21N4LbiEjN+Xzw7PV+O5rRfpV+qKc/qB1Qcv3Bh8qM2Cqp
 LOVmedBkLFCDUunhZK7+uVfED5J4wMRYY15LPWQnGrTg621ytFAXUUYz3uzaFKBBLzN0i8
 qhEoO4KBEmd/bwJdP0BE37kGSsFiv+w=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-5_8dsOENMfq_arwP8LA1bg-1; Tue, 17 May 2022 13:27:40 -0400
X-MC-Unique: 5_8dsOENMfq_arwP8LA1bg-1
Received: by mail-ej1-f70.google.com with SMTP id
 sc20-20020a1709078a1400b006f4a358c817so7694101ejc.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2022 10:27:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=KKq680AnszBszJpoGIG9251C41AK5g6xGWKr2ftGslI=;
 b=vTKRJD5E2NEihoJJJiXxCkBqntPuWTaSLkPPvmYJBs7H3iKhWYRyTVNR5rHsHFCOyM
 g1neRlGvuYoppPByWzcZn6x55HLBp6xiVn0tLVwgTx2g75lq40b3zNj8fOGzhZwmkT/G
 gDHoGFun8SW3Gf3FSEWR5ikV9nCmMDNC/XP5G2XCENo+hr6TUpUvqT5QuEbz3z+pR+5Q
 oqbeNzHZ9c5qXE9ZUybOtKZlqs6Cf1RgcTF+YbY8wYTD8A22wb8YMeAe14jzMNxtkPk5
 9MrIC+7zD47FZt5UBwJf2xXKgBVWP94F7WzP0z7m6qY31BaqAPsKz+8rwkdE2EXIr7NZ
 kP3w==
X-Gm-Message-State: AOAM531gNRyjE9HasiaQKF2mNV7/F+xf+KaZNljLQMrdjE08PfwvPhHP
 M9CyVioXdzkinnLHr13IPYjq7qhxJh1WEvkcRf/cPFudSYrgztFYimhTBnsftFyRO1Hb478VT+M
 07QF0rafioKoS/xlioY5RVQ//
X-Received: by 2002:aa7:cd87:0:b0:427:f800:220d with SMTP id
 x7-20020aa7cd87000000b00427f800220dmr20576170edv.112.1652808459213; 
 Tue, 17 May 2022 10:27:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxC3PVDHfL41xd+PMS921zEyYofQiMDC6L+gf8Y0ZLX22T50TYUkDJEchPjpPGtx0JkS++qnA==
X-Received: by 2002:aa7:cd87:0:b0:427:f800:220d with SMTP id
 x7-20020aa7cd87000000b00427f800220dmr20576144edv.112.1652808459006; 
 Tue, 17 May 2022 10:27:39 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id
 u2-20020aa7db82000000b0042617ba63a7sm7196571edt.49.2022.05.17.10.27.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 17 May 2022 10:27:38 -0700 (PDT)
Message-ID: <64895c87-743f-191d-b28e-dc8f17508773@redhat.com>
Date: Tue, 17 May 2022 19:27:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.18, take #3
To: Marc Zyngier <maz@kernel.org>
References: <20220516125151.955808-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220516125151.955808-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 5/16/22 14:51, Marc Zyngier wrote:
> Paolo,
> 
> Here's the third (and hopefully final) set of fixes for 5.18. Two
> rather simple patches: one addressing a userspace-visible change in
> behaviour with GICv3, and a fix for pKVM in combination with CPUs
> affected by Spectre-v3a.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 85ea6b1ec915c9dd90caf3674b203999d8c7e062:
> 
>    KVM: arm64: Inject exception on out-of-IPA-range translation fault (2022-04-27 23:02:23 +0100)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.18-3
> 
> for you to fetch changes up to 2e40316753ee552fb598e8da8ca0d20a04e67453:
> 
>    KVM: arm64: Don't hypercall before EL2 init (2022-05-15 12:14:14 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.18, take #3
> 
> - Correctly expose GICv3 support even if no irqchip is created
>    so that userspace doesn't observe it changing pointlessly
>    (fixing a regression with QEMU)
> 
> - Don't issue a hypercall to set the id-mapped vectors when
>    protected mode is enabled
> 
> ----------------------------------------------------------------
> Marc Zyngier (1):
>        KVM: arm64: vgic-v3: Consistently populate ID_AA64PFR0_EL1.GIC
> 
> Quentin Perret (1):
>        KVM: arm64: Don't hypercall before EL2 init
> 
>   arch/arm64/kvm/arm.c      | 3 ++-
>   arch/arm64/kvm/sys_regs.c | 3 +--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
