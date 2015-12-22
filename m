From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: kvmarm tags kvm-arm-for-4.2, 4.3, and v4.4-rc6 does not boot on
 Mustang
Date: Tue, 22 Dec 2015 18:33:26 +0900
Message-ID: <567918E6.8020001@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F41441267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 04:30:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5Gzj1Vh-wnjz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Dec 2015 04:30:45 -0500 (EST)
Received: from postman.riken.jp (postman3.riken.jp [134.160.33.85])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C4EA3411E3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 04:30:45 -0500 (EST)
Received: from postman.riken.jp (localhost.localdomain [127.0.0.1])
 by postman.riken.jp (Postfix) with SMTP id 9C4E094134
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 18:33:26 +0900 (JST)
Received: from MacBook-Pro.local (KD111105169138.ppp-bb.dion.ne.jp
 [111.105.169.138])
 by postman.riken.jp (Postfix) with ESMTPA id 7A79C94101
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Dec 2015 18:33:26 +0900 (JST)
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

Hi,
I have been trying to test one of the recent tags in kvmarm git tree,
kvm-arm-for-4.2, 4.3, and v4.4-rc6 on Mustang, but none of them seem
to enter the linux boot process. Has anyone verified any of these work
on Mustang? If so can I have a working .config to continue testing?

Itaru
