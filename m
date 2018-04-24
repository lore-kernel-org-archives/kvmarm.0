From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: Migration with directly assigned devices is possible?
Date: Tue, 24 Apr 2018 19:13:56 +0200
Message-ID: <b0271fcf-283d-c4a3-5864-d8c03fd41702@redhat.com>
References: <CAHyh4xjW9P2N9Dw6AasuX7=dcdJeiW2be1nZsZRWMxnpp6Xhmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4C2F49F8B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:05:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N6zD793ui15X for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Apr 2018 13:04:46 -0400 (EDT)
Received: from mail-wr0-f172.google.com (mail-wr0-f172.google.com
 [209.85.128.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC40249F7E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 13:04:37 -0400 (EDT)
Received: by mail-wr0-f172.google.com with SMTP id c14-v6so10593990wrd.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:14:00 -0700 (PDT)
In-Reply-To: <CAHyh4xjW9P2N9Dw6AasuX7=dcdJeiW2be1nZsZRWMxnpp6Xhmw@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jintack Lim <jintack@cs.columbia.edu>, KVM General <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 24/04/2018 16:56, Jintack Lim wrote:
> Hi,
> 
> I wonder if we can do migration with directly assigned devices (i.e.
> pass-through devices)? I looked at the KVM migration page[1], but
> couldn't find information. Can somebody let me now if it's possible or
> point me the related documents?

No, it's not possible.  Various device-specific methods have been
proposed, but none has ever been included into either VFIO or QEMU.

Thanks,

Paolo
