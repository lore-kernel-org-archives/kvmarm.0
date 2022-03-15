Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A15C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 07:46:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCE5A404FD;
	Tue, 15 Mar 2022 03:46:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 442ExAxPrbb2; Tue, 15 Mar 2022 03:46:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AB0B49E3F;
	Tue, 15 Mar 2022 03:46:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DB4949E17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9DwL1J4BmAYA for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 03:46:47 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7A9404FD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 03:46:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647330406;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=jWeRmNoHqA79eh4aTLJgqBLVAPL7D60jcq/uE/nVP+g=;
 b=N9+Wuu2666HEX3UqTiKtRHbYPSm/FnRO1maniq8E6CvcJVzNUK4/C7btB6zyWMhpNIXRWu
 KgenoJCGecJjchgi+QfYZBN7T1ws1haDqvNZchObYpTcYAD2Fz0DppRTLsRSTNuQTvoq2n
 HH9Uf3PP7tpf+x4kQIO+9VgPiY8682A=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-cUGbbxPkMVyc8o0S0Bva4Q-1; Tue, 15 Mar 2022 03:46:44 -0400
X-MC-Unique: cUGbbxPkMVyc8o0S0Bva4Q-1
Received: by mail-pl1-f199.google.com with SMTP id
 c10-20020a170902d48a00b00151cf8ca3c7so7907334plg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 00:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=jWeRmNoHqA79eh4aTLJgqBLVAPL7D60jcq/uE/nVP+g=;
 b=2TmwAxudXYsp23vTT71fQ8zEmk+72/zJ8FbAa1BXIxzu+0QnhrBI3cJO/fzzK3Wvxi
 VrHTuwKKgA4gtyNBuPqYGVUvuAAbo5qcgsMN1/z5eek0AN2rNd+ZCppibAANFsNb4Z/G
 WjHAyQRbCgQ4FXqfe4yR6Z6TlVKXbyJuC1QG6IN8cdJs0sXdi8ifw8aKGxUlq9SyJ9H1
 dpGqE8lmdKh7uI4NCRMyCif5QKS2gzXn3j/Q3g/1Dq22Yaq3l/sl5/t8/xRi1a+HwGO+
 xT7++67KE4lKtTBtJ/zbK8nUYEigNrwLuv95n7R+UPr+X9a/0gowWGp3alrVbFSUGhkR
 GMxg==
X-Gm-Message-State: AOAM532bnnkXnr+lxYtdWWWsHla/OnIKet2ZuDNi/FD+0wmgnSKlu+CR
 ayJloGNtANwVSn8Ye5ENpJuu3XgevEIdundplWZIFuQWXUpNtlTW3EvxeupUwp0ayeHb5lT1o53
 PwgCrAzjDe+cvTZ62kNzpZQhz
X-Received: by 2002:a17:90b:3a81:b0:1c2:bf38:b57a with SMTP id
 om1-20020a17090b3a8100b001c2bf38b57amr3181535pjb.172.1647330403431; 
 Tue, 15 Mar 2022 00:46:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7FLPnde4MmAng4UXgI9r1HTOD3VSQ8zmxvVJmWLA5YqMaBNH24gOlC5XFnQFle7qC0BS3aA==
X-Received: by 2002:a17:90b:3a81:b0:1c2:bf38:b57a with SMTP id
 om1-20020a17090b3a8100b001c2bf38b57amr3181502pjb.172.1647330403166; 
 Tue, 15 Mar 2022 00:46:43 -0700 (PDT)
Received: from xz-m1.local ([191.101.132.43]) by smtp.gmail.com with ESMTPSA id
 s30-20020a056a001c5e00b004f75773f3fcsm22480075pfw.119.2022.03.15.00.46.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 00:46:42 -0700 (PDT)
Date: Tue, 15 Mar 2022 15:46:34 +0800
From: Peter Xu <peterx@redhat.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 02/26] KVM: x86/mmu: Use a bool for direct
Message-ID: <YjBEWm3YsuSKj+ES@xz-m1.local>
References: <20220311002528.2230172-1-dmatlack@google.com>
 <20220311002528.2230172-3-dmatlack@google.com>
MIME-Version: 1.0
In-Reply-To: <20220311002528.2230172-3-dmatlack@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=peterx@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Mar 11, 2022 at 12:25:04AM +0000, David Matlack wrote:
> The parameter "direct" can either be true or false, and all of the
> callers pass in a bool variable or true/false literal, so just use the
> type bool.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

If we care about this.. how about convert another one altogether?

TRACE_EVENT(kvm_hv_stimer_expiration,
	TP_PROTO(int vcpu_id, int timer_index, int direct, int msg_send_result),
	TP_ARGS(vcpu_id, timer_index, direct, msg_send_result),

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
