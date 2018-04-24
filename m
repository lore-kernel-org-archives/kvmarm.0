From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Re: Migration with directly assigned devices is possible?
Date: Tue, 24 Apr 2018 13:23:47 -0400
Message-ID: <CAHyh4xgEknqeGjTmziDQnA1kzbvSCBdS_BzQpEJruzM4iqdECA@mail.gmail.com>
References: <CAHyh4xjW9P2N9Dw6AasuX7=dcdJeiW2be1nZsZRWMxnpp6Xhmw@mail.gmail.com>
 <b0271fcf-283d-c4a3-5864-d8c03fd41702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE4B40478
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:14:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eYszqt959Yyp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Apr 2018 13:14:28 -0400 (EDT)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 812A040357
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:14:28 -0400 (EDT)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w3OHLvaK001288
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:23:51 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id F1BE16D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:23:50 -0400 (EDT)
Received: from sendprodmail02.cc.columbia.edu (sendprodmail02.cc.columbia.edu
 [128.59.72.14]) by hazelnut (Postfix) with ESMTP id DBF116D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:23:50 -0400 (EDT)
Received: from mail-wr0-f197.google.com (mail-wr0-f197.google.com
 [209.85.128.197])
 by sendprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w3OHNouE033444
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:23:50 -0400
Received: by mail-wr0-f197.google.com with SMTP id c56-v6so22995116wrc.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:23:50 -0700 (PDT)
Received: from mail-wm0-f42.google.com (mail-wm0-f42.google.com.
 [74.125.82.42])
 by smtp.gmail.com with ESMTPSA id q19sm9557119edd.39.2018.04.24.10.23.48
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 24 Apr 2018 10:23:48 -0700 (PDT)
Received: by mail-wm0-f42.google.com with SMTP id x12so1406745wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:23:48 -0700 (PDT)
In-Reply-To: <b0271fcf-283d-c4a3-5864-d8c03fd41702@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, KVM General <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Apr 24, 2018 at 1:13 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> On 24/04/2018 16:56, Jintack Lim wrote:
>> Hi,
>>
>> I wonder if we can do migration with directly assigned devices (i.e.
>> pass-through devices)? I looked at the KVM migration page[1], but
>> couldn't find information. Can somebody let me now if it's possible or
>> point me the related documents?
>
> No, it's not possible.  Various device-specific methods have been
> proposed, but none has ever been included into either VFIO or QEMU.
>

Thanks for letting me know, Paolo!!

Best,
Jintack

> Thanks,
>
> Paolo
>
