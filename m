From: hiwu <hiwu@derytech.com.tw>
Subject: ARM32 guest on ARM64 host
Date: Sat, 25 Jun 2016 12:31:50 +0800
Message-ID: <f47a31f2-3f61-e2c7-a7c0-43dadd93b765@derytech.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB92D49B4A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 00:26:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YlsNZZzdHvNA for <kvmarm@lists.cs.columbia.edu>;
 Sat, 25 Jun 2016 00:26:32 -0400 (EDT)
Received: from msr12.hinet.net (msr12.hinet.net [168.95.4.112])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B724A48529
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 00:26:31 -0400 (EDT)
Received: from dns.derytech.com.tw (218-161-54-187.HINET-IP.hinet.net
 [218.161.54.187])
 by msr12.hinet.net (8.14.9/8.14.9) with ESMTP id u5P4VTSU012829
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 12:31:30 +0800 (CST)
Received: from [192.168.0.102] (1-160-18-13.dynamic.hinet.net [1.160.18.13])
 (Authenticated sender: hiwu@derytech.com.tw)
 by dns.derytech.com.tw (Postfix) with ESMTPA id 3E9A0A601D0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 25 Jun 2016 12:31:28 +0800 (CST)
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

Hi all :

1) Can Arm64 Linux host enable KVM support for Arm32 guest ?
2) Can qemu-system-arm on Arm64 Linux host use the aarch32 KVM feature 
on Arm64 host ?

Thank you

-Jack
