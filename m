Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2A67C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Mar 2022 15:25:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3819F49F16;
	Tue, 15 Mar 2022 11:25:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2HOelTy6EswE; Tue, 15 Mar 2022 11:25:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C76DA49F07;
	Tue, 15 Mar 2022 11:25:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6CF849F07
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 11:25:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dW0B20HZBPDZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Mar 2022 11:25:36 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81DD649F02
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 11:25:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1647357936;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=+vHON9sLMUnWuhzssX9l36MlFGplt76F/UZcJvgCxP4=;
 b=JZVdYH7Wwhz+Zg5e76jdkvJjunM+9B28ypo+lrsakjZI/EdM8E3s6HufIfZ2KglDZcJgcS
 CK9rBf6A7hB++yu1YxgupuKYEox/KPVxxzvmQNubI/PCuJYi7Ie+CSQggRVmGwjrJm33Nj
 lRFXlGThgDSnOufgJlOxN453BXWd4NI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-joT0b04OM7OjfXhlQ5EMQA-1; Tue, 15 Mar 2022 11:25:32 -0400
X-MC-Unique: joT0b04OM7OjfXhlQ5EMQA-1
Received: by mail-wr1-f69.google.com with SMTP id
 e6-20020a5d4e86000000b001f045d4a962so5408444wru.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Mar 2022 08:25:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=+vHON9sLMUnWuhzssX9l36MlFGplt76F/UZcJvgCxP4=;
 b=5EUxK4uUNvfuZR7c8daNzR98esrJEzEVr1Uw6Sb2NQqShFiC1woXKWvJfPp5x5Ybcr
 7fk5QeNmoGsOqsj4rBr1tj/5vRG6ScJLQheVEtCDj0yM2zHvjY5APv2BJNJUIklge43H
 O6bA9uVdg2dITbMa2zFfQ3O+aKMieo6V3Cm6FL4PLxGAqhNLzjSOxX1kUsOutD5cc7cf
 11KDvV9RA1BmHSl8BuiXsl9JRsG4PabkCiqCwbBlCzXIrQwbp2hWupwo5Asseur90/xU
 EJcdVYEsDEvespKunstSpv/sKX098dDjZdtO8vPjooGirAZl5TH9wieTskZo3iw5Y5fe
 Wkiw==
X-Gm-Message-State: AOAM531A9lscdulRL/QiovIEmLELRQ5rRCdqd61LC2ejubt7HQuuBsai
 WGSB2TJVT3RgfUTDmdtjtTm2pnXI0swGGuSxhzCSE2HBH1PgU+I7cT9MBMpFEVY7cdkD6eQZUZC
 fJ/xrXY3M4J+m9dsi9FOL/dZH
X-Received: by 2002:adf:d1eb:0:b0:203:9349:12b5 with SMTP id
 g11-20020adfd1eb000000b00203934912b5mr17160913wrd.285.1647357931075; 
 Tue, 15 Mar 2022 08:25:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz2ee9e3ZcJNtbvd1Kl1w+g+2sYRYd7utinJ9zHtcCamj5vcsF8wTRZt4xGOXgYc/WbZJf1CQ==
X-Received: by 2002:adf:d1eb:0:b0:203:9349:12b5 with SMTP id
 g11-20020adfd1eb000000b00203934912b5mr17160901wrd.285.1647357930888; 
 Tue, 15 Mar 2022 08:25:30 -0700 (PDT)
Received: from gator (cst2-173-70.cust.vodafone.cz. [31.30.173.70])
 by smtp.gmail.com with ESMTPSA id
 e6-20020a5d5006000000b0020374784350sm15897016wrt.64.2022.03.15.08.25.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 15 Mar 2022 08:25:30 -0700 (PDT)
Date: Tue, 15 Mar 2022 16:25:28 +0100
From: Andrew Jones <drjones@redhat.com>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests] Adding the QCBOR library to kvm-unit-tests
Message-ID: <20220315152528.u7zdkjlq6okahidm@gator>
References: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
MIME-Version: 1.0
In-Reply-To: <YjCVxT1yo0hi6Vdc@monolith.localdoman>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: thuth@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Mar 15, 2022 at 01:33:57PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> Arm is planning to upstream tests that are being developed as part of the
> Confidential Compute Architecture [1]. Some of the tests target the
> attestation part of creating and managing a confidential compute VM, which
> requires the manipulation of messages in the Concise Binary Object
> Representation (CBOR) format [2].
> 
> I would like to ask if it would be acceptable from a license perspective to
> include the QCBOR library [3] into kvm-unit-tests, which will be used for
> encoding and decoding of CBOR messages.
> 
> The library is licensed under the 3-Clause BSD license, which is compatible
> with GPLv2 [4]. Some of the files that were created inside Qualcomm before
> the library was open-sourced have a slightly modified 3-Clause BSD license,
> where a NON-INFRINGMENT clause is added to the disclaimer:
> 
> "THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
> WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE **AND NON-INFRINGEMENT**
> ARE DISCLAIMED" (emphasis by me on the added clause).
> 
> The files in question include the core files that implement the
> encode/decode functionality, and thus would have to be included in
> kvm-unit-tests. I believe that the above modification does not affect the
> compatibility with GPLv2.
> 
> I would also like to mention that the QCBOR library is also used in Trusted
> Firmware-M [5], which is licensed under BSD 3-Clause.
> 
> [1] https://www.arm.com/architecture/security-features/arm-confidential-compute-architecture
> [2] https://datatracker.ietf.org/doc/html/rfc8949
> [3] https://github.com/laurencelundblade/QCBOR
> [4] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses
> [5] https://git.trustedfirmware.org/TF-M/trusted-firmware-m.git/tree/lib/ext/qcbor
> 
> Thanks,
> Alex
>

Assuming the license is OK (I'm not educated in that stuff enough to give
an opinion), then the next question is how do we want to integrate it?
Bring it all in, like we did libfdt? Or use a git submodule?

Thanks,
drew 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
