From: hiwu@derytech.com.tw
Subject: ARM KVM guest virtual address to host virtual address Look up
Date: Fri, 15 Jan 2016 17:33:36 +0800
Message-ID: <911dda08e570d71c948d7f9dad3e3e04.squirrel@mail.derytech.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43076499E0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 04:32:22 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fRwd3v3hcqw6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 04:32:20 -0500 (EST)
Received: from msr15.hinet.net (msr15.hinet.net [168.95.4.115])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 036EB499DE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 04:32:19 -0500 (EST)
Received: from dns.derytech.com.tw (218-161-54-187.HINET-IP.hinet.net
 [218.161.54.187])
 by msr15.hinet.net (8.14.9/8.14.9) with ESMTP id u0F9aTm7010039
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 17:36:30 +0800 (CST)
Received: from mail.derytech.com.tw (218-161-54-187.HINET-IP.hinet.net
 [218.161.54.187]) (Authenticated sender: hiwu@derytech.com.tw)
 by dns.derytech.com.tw (Postfix) with ESMTPA id 55F88A6045C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 17:33:35 +0800 (CST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi:

How to lookup host virtual address by guest virtual address ?
Is there any function to do guest page table walk?

Thank you

-Jack
