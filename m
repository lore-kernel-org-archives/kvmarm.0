Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34003C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Jan 2022 15:43:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 880B94B293;
	Fri,  7 Jan 2022 10:43:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sM4952TtxNHs; Fri,  7 Jan 2022 10:43:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33EB54B292;
	Fri,  7 Jan 2022 10:43:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E8744B291
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 10:43:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id joqT4OzTg2qE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Jan 2022 10:43:26 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E32AA4B292
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Jan 2022 10:43:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1641570206;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TzpRVERh4CRAMa9TDU7mZpEigQ9ChriGr62E18b9bII=;
 b=iun5KDhy0rPMU8AcJB4PhMigJ7WNXlLyIcP54/g5LNKTQsbI46gYuI0nl81REfQNFGGJ7H
 l1Pcs/xeUa+yDc7wrMYQ1+Ly/wdaxBbKqNJg9cSMPFXeqCbMqB9t7mBOWxe/08PI0RpQQO
 VGZHyAXdSu+Ob4mYbGmjBfbOFtOi+HM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-324-ae4RdLVXPymAOG37n8yRqg-1; Fri, 07 Jan 2022 10:43:25 -0500
X-MC-Unique: ae4RdLVXPymAOG37n8yRqg-1
Received: by mail-ed1-f70.google.com with SMTP id
 ec25-20020a0564020d5900b003fc074c5d21so641135edb.19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Jan 2022 07:43:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=TzpRVERh4CRAMa9TDU7mZpEigQ9ChriGr62E18b9bII=;
 b=QvCpbEWpdLwLxTmHLspCwmVGL9fUOAN8dqh0dxj2VSw0kn27Oqr3sHRjKTEd5ThC4I
 /epRmDC14wNxJg8iUz+QLzdoRLqKMhj7T4UrlpznX9XlB8CMnfgpQop+JfsuxdLK6FPd
 OmBkCIchOsDUtzcy3vb4fXrzpsVdLeQkfT4nbd0SC1Hx4r7KgzE5zbUAtIo0ppzFjj1L
 XTo9q1k6PF8023nZ/+j9f5B+hyXf9lOoQIvOKFlyhdAnpTz9vgqNuKav2NdwyDE9uY2t
 1dr1j3GySsHQKYOT9SZjR5Efd0Fwh60HC2HdfsUi2MNUKGAkOemyBVbozEsuKwS8yQgN
 ulaw==
X-Gm-Message-State: AOAM533WEGyUcEpfO88HGBfk89BjuFSLK4jk1oFvLljNtUk7Rbx/DAFy
 Up03vixWjGnyMGvncT3sKvpyZZsNtueG8nd5U3iDLMs4XI65VawWOko80mYHPyEXDaeU69NcoqE
 f5pQ4g5CakBEwKyVaq+kdySVQ
X-Received: by 2002:a17:907:7ea6:: with SMTP id
 qb38mr7091891ejc.59.1641570203959; 
 Fri, 07 Jan 2022 07:43:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyxleSjgznkzD99+meoFB9zsvvczl06qss5ywcdrcu34Oa7shLFaOgetnQXKpsZe6D6Mcp5kA==
X-Received: by 2002:a17:907:7ea6:: with SMTP id
 qb38mr7091865ejc.59.1641570203730; 
 Fri, 07 Jan 2022 07:43:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id ga10sm560120ejc.12.2022.01.07.07.43.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 07 Jan 2022 07:43:23 -0800 (PST)
Message-ID: <896a998b-17b6-7f50-8f23-b14ff8f44333@redhat.com>
Date: Fri, 7 Jan 2022 16:43:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.17
To: Marc Zyngier <maz@kernel.org>
References: <20220107114548.4069893-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220107114548.4069893-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andrew Walbran <qwandor@google.com>, Will Deacon <will@kernel.org>,
 Rikard Falkeborn <rikard.falkeborn@gmail.com>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel@lists.infradead.org,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 kvmarm@lists.cs.columbia.edu
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

On 1/7/22 12:45, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the bulk of the KVM/arm64 updates for 5.17. No real new feature
> this time around, but a bunch of changes that will make the merging of
> upcoming features easier (pKVM is reaching a point where it will
> finally be usable, and NV isn't too far off... fingers crossed). This
> comes with the usual set of bug fixes and cleanups all over the shop.
> 
> We also have a sizeable chunks of selftest updates which probably
> account for half of the changes.

Pulled, thanks!

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
