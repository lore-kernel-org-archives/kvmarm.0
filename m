Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B18C43334
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jun 2022 14:41:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C5AF4B0D9;
	Tue, 21 Jun 2022 10:41:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ah6n03kIW6sy; Tue, 21 Jun 2022 10:41:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2059A49ED6;
	Tue, 21 Jun 2022 10:41:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C3149EBC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:41:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XPySzTBsBM+D for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jun 2022 10:41:07 -0400 (EDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
 [209.85.216.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CD97E49EB2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 10:41:07 -0400 (EDT)
Received: by mail-pj1-f53.google.com with SMTP id
 t3-20020a17090a510300b001ea87ef9a3dso13593184pjh.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jun 2022 07:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JOicc8moSgPUHZwRa0UCLUvVifYA0qTN8DaBzCizOgw=;
 b=cKCuyyDnkfNQBL6avZcuKqgcaAnrDgGaMrPVXHKS56JghxcscK9NoNnj3Fq7/NVRC+
 oRVzrbe4sEZRyZOqRivaOWFZO8Gd7vthX9YgbDCc1RkeiGegxd0pyZQqGZ/UzgMt5ruJ
 MaD7F/sfEkQoWFzd4qxP745PX7p+Gml77tWHRrjRjkZiJB4Si0+QNOhldE61LLtgrKtz
 z7nAckxCBVmBlyIGhrdH+2BUYxEDwzsjv/pBBt1WZ1hcXBLEmjxXq9UXzk0BiNzqacIe
 VkYCNWJt/9iPC5J8GLSnvPOdHVjKAoDqjVqKQeMuB+EOm3tQprFc1Ew0wMXup3tiDdCK
 rfwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JOicc8moSgPUHZwRa0UCLUvVifYA0qTN8DaBzCizOgw=;
 b=OJ4JIJrkoFTnU2IAgpCDDWl/TaIK0g9yFwhbkIGRR+P/k+O8RQ7R6pbyJvBXvI5Xvp
 NEmZ8YsKC1N/cHDpc68lusAmqgDjsiqDPwmBwfy5gTeMPJTytRbIKw8AX+WX0oI5zAGl
 Oo/JH9ZBkPIitn1d1iPRV26MuafRyB2/4lJagEO5ktowedgQ8M3O5ywzg+iGTiDyVp9v
 XPb3po8NZN+5cfRgu/XdDm4kikNFQ5HPlqrfttVV7e0FxMG8AHhy2ppMAZWY+mgyGTYH
 uUsHue5CCB7QkkIzZkWRtIWdq2M1bes0Yfv7u/UceG4uDn+tTCTlBdv/cRmnw74HdiJv
 F7lQ==
X-Gm-Message-State: AJIora+ynemuidDOZLEZWamkYM4+gWr3ugh91qtQRARvKoyVTQ4yEfpq
 PZDXZj6qFRI1Z9FtNuv1a7gXSw==
X-Google-Smtp-Source: AGRyM1vJrRABFv+Um9W+VY7dY1s+g55BsfMNsbio+5fYQj4/zIQK6olfXAORs7KW0GbN7wK+7Xjx+Q==
X-Received: by 2002:a17:902:ab87:b0:162:26cf:bf7a with SMTP id
 f7-20020a170902ab8700b0016226cfbf7amr28637304plr.168.1655822466277; 
 Tue, 21 Jun 2022 07:41:06 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 s17-20020a170902c65100b0016a091e993dsm8269986pls.42.2022.06.21.07.41.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 21 Jun 2022 07:41:05 -0700 (PDT)
Date: Tue, 21 Jun 2022 14:41:02 +0000
From: Sean Christopherson <seanjc@google.com>
To: "Huang, Shaoqin" <shaoqin.huang@intel.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Consolidate boilerplate code in
 get_ucall()
Message-ID: <YrHYfiI+54hAp0vv@google.com>
References: <20220618001618.1840806-1-seanjc@google.com>
 <20220618001618.1840806-3-seanjc@google.com>
 <de35d629-e076-e02d-7482-c93de628dd82@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <de35d629-e076-e02d-7482-c93de628dd82@intel.com>
Cc: kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Colton Lewis <coltonlewis@google.com>, linux-riscv@lists.infradead.org,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Atish Patra <atishp@atishpatra.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>
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

On Sun, Jun 19, 2022, Huang, Shaoqin wrote:
> 
> 
> On 6/18/2022 8:16 AM, Sean Christopherson wrote:
> > Consolidate the actual copying of a ucall struct from guest=>host into
> > the common get_ucall().  Return a host virtual address instead of a guest
> > virtual address even though the addr_gva2hva() part could be moved to
> > get_ucall() too.  Conceptually, get_ucall() is invoked from the host and
> > should return a host virtual address (and returning NULL for "nothing to
> > see here" is far superior to returning 0).
> 
> It seems the get_ucall() returns the uc->cmd, the ucall_arch_get_ucall()
> returns a host virtual address.

Yep, get_ucall() then does the memcpy() from guest memory via that host virtual
addres and returns the resulting ucall command.  The intent is that the arch
hooks are not to be called by common code.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
