Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FC5C35250
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:37:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 72373214AF
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:37:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MifKiWnC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72373214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8B0D4A588;
	Fri,  7 Feb 2020 11:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FTjXIbThMo4L; Fri,  7 Feb 2020 11:37:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9ABCC4A51F;
	Fri,  7 Feb 2020 11:37:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CE1C4A418
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:37:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o2P+SjdLHOld for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 11:37:48 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1FDF4A51F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:37:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581093468;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Kvzyalww/whqgM6x9oBUKbglc/i5Jao1bW6lbVLXvlE=;
 b=MifKiWnCMoSe3u2wGVvePC1HAy4jNhDk2b/BF48gBRV/ZAXcDul+OQ5hpQYv3mpxsJSOBi
 0D8iz7Q8izxx+f8xpZUil17FrRTfbn2JnVChIYZhNKAVEzbRh+5y29s78ObziXeJNnLY58
 sZ4ljrpi4ODPQSmhsRvOcAMTPubvPKk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-hwJvp5tPMqSjHQDEunHuCg-1; Fri, 07 Feb 2020 11:37:44 -0500
Received: by mail-qt1-f198.google.com with SMTP id z11so2005581qts.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Feb 2020 08:37:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=cgH9xO+cWS+9pXG73bIgnka4EVIZlSpUaEw9L/nO7Zs=;
 b=psm5kD4+NkSUIf46TcGU7pQ56mQjz7SjB8tZXpY6cqUGOgcURfWSzNeZMII7BAMeuB
 GG3mZWGhEM5LtMdSpcTX9THkDSEhTs2hOM+rtFYkneV9gbLYdgrWGzXYG0HTm3Iwrk5R
 We32/WSbOPilzEOtbbdeYsvOgAnYBC02nMzugUqMTc/5V23SgaGrdm0utWqTm6lsPKbK
 kqtVEuTohTDVoySPVvPtyCQ7QgkMYeqpaxerSdUdgihjKOba5dOzZqUjFQSKq0ILlrSp
 aldEqh/P9dAO8Rv4fH0eS0+j+2SKT398h4zJwcQyau3lvQDKZTLflyv/MK+HL7g5HMc8
 cECw==
X-Gm-Message-State: APjAAAXm8mMKj5FTEDCC1nEitlIZMR89UzI0ete01LdJ6IOMHErju3M3
 BJ9Rao7OYlgqt3aYwzZINL3n350dLkEHfjwQ3vlGR7KDgpi5NwDFw/YaHAyrVcsv+iJzEbViQwR
 MR07to6XoepjoT20SolfMmKUR
X-Received: by 2002:a05:6214:11ac:: with SMTP id
 u12mr7667079qvv.85.1581093464516; 
 Fri, 07 Feb 2020 08:37:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqyADx3loVUdRKb44G4UQsDsAdknpBOKbHmW0fDqmSZoyg4OJXL3ZNHkOudrrNbkAu5Phy9RLA==
X-Received: by 2002:a05:6214:11ac:: with SMTP id
 u12mr7667045qvv.85.1581093464263; 
 Fri, 07 Feb 2020 08:37:44 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
 by smtp.gmail.com with ESMTPSA id 124sm1548666qko.11.2020.02.07.08.37.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 07 Feb 2020 08:37:43 -0800 (PST)
Date: Fri, 7 Feb 2020 11:37:40 -0500
From: Peter Xu <peterx@redhat.com>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200207163740.GA720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
 <20200206221208.GI700495@xz-x1>
 <20200207153829.GA2401@linux.intel.com>
 <20200207160546.GA707371@xz-x1>
 <20200207161553.GE2401@linux.intel.com>
MIME-Version: 1.0
In-Reply-To: <20200207161553.GE2401@linux.intel.com>
X-MC-Unique: hwJvp5tPMqSjHQDEunHuCg-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-mips@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>,
 Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
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

On Fri, Feb 07, 2020 at 08:15:53AM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2020 at 11:05:46AM -0500, Peter Xu wrote:
> > On Fri, Feb 07, 2020 at 07:38:29AM -0800, Sean Christopherson wrote:
> > > On Thu, Feb 06, 2020 at 05:12:08PM -0500, Peter Xu wrote:
> > > > This patch is tested so I believe this works, however normally I need
> > > > to do similar thing with [0] otherwise gcc might complaint.  Is there
> > > > any trick behind to make this work?  Or is that because of different
> > > > gcc versions?
> > > 
> > > array[] and array[0] have the same net affect, but array[] is given special
> > > treatment by gcc to provide extra sanity checks, e.g. requires the field to
> > > be the end of the struct.  Last I checked, gcc also doesn't allow array[]
> > > in unions.  There are probably other restrictions.
> > > 
> > > But, it's precisely because of those restrictions that using array[] is
> > > preferred, as it provides extra protections, e.g. if someone moved memslots
> > > to the top of the struct it would fail to compile.
> > 
> > However...
> > 
> > xz-x1:tmp $ cat a.c
> > struct a {
> >     int s[];
> > };
> > 
> > int main(void) { }
> > xz-x1:tmp $ make a
> > cc     a.c   -o a
> > a.c:2:9: error: flexible array member in a struct with no named members
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> gcc is telling you quite explicitly why it's angry.  Copy+paste from the
> internet[*]:
> 
>   Flexible Array Member(FAM) is a feature introduced in the C99 standard of the
>   C programming language.
> 
>   For the structures in C programming language from C99 standard onwards, we
>   can declare an array without a dimension and whose size is flexible in nature.
> 
>   Such an array inside the structure should preferably be declared as the last 
>   member of structure and its size is variable(can be changed be at runtime).
>   
>   The structure must contain at least one more named member in addition to the
>   flexible array member. 
> 
> [*] https://www.geeksforgeeks.org/flexible-array-members-structure-c/

Sorry again for not being able to identify the meaning of that
sentence myself.  My English is probably even worse than I thought...

So I think my r-b keeps.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
