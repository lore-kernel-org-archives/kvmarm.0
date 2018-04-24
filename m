From: Jintack Lim <jintack@cs.columbia.edu>
Subject: Migration with directly assigned devices is possible?
Date: Tue, 24 Apr 2018 10:56:16 -0400
Message-ID: <CAHyh4xjW9P2N9Dw6AasuX7=dcdJeiW2be1nZsZRWMxnpp6Xhmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE94249F7F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:47:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vzM+ChhOZ-om for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Apr 2018 10:47:03 -0400 (EDT)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4582A49EA4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:47:03 -0400 (EDT)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w3OEuPp3024294
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:56:25 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 172EFDB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:56:25 -0400 (EDT)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 170EE81
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:56:20 -0400 (EDT)
Received: from mail-wm0-f70.google.com (mail-wm0-f70.google.com [74.125.82.70])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id w3OEuJfF026426
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 10:56:19 -0400
Received: by mail-wm0-f70.google.com with SMTP id i131so330062wmf.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 07:56:19 -0700 (PDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com.
 [74.125.82.41])
 by smtp.gmail.com with ESMTPSA id d9sm9191327edm.74.2018.04.24.07.56.17
 for <kvmarm@lists.cs.columbia.edu>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Tue, 24 Apr 2018 07:56:17 -0700 (PDT)
Received: by mail-wm0-f41.google.com with SMTP id l16so1401323wmh.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Apr 2018 07:56:17 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: KVM General <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I wonder if we can do migration with directly assigned devices (i.e.
pass-through devices)? I looked at the KVM migration page[1], but
couldn't find information. Can somebody let me now if it's possible or
point me the related documents?

Thanks,
Jintack


[1] https://www.linux-kvm.org/page/Migration
