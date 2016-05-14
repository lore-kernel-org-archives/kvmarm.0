From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Sat, 14 May 2016 23:58:23 +0900
Message-ID: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67D9349B1A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 May 2016 10:55:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UuIWqSU3QK8r for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 May 2016 10:55:19 -0400 (EDT)
Received: from postman.riken.jp (postman4.riken.jp [134.160.33.86])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0C924998D
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 May 2016 10:55:19 -0400 (EDT)
Received: from postman.riken.jp (localhost.localdomain [127.0.0.1])
 by postman.riken.jp (Postfix) with SMTP id 064235981F3
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 May 2016 23:58:24 +0900 (JST)
Received: from MacBook-Pro.local (KD111105169138.ppp-bb.dion.ne.jp
 [111.105.169.138])
 by postman.riken.jp (Postfix) with ESMTPA id BDFC75981D8
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 May 2016 23:58:23 +0900 (JST)
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

The tag kvm-arm-for-4.7 fails to boot on Mustang. Has anyone verified 
this tag on Mustang? The F/W I'm using is 3.05.05-beta_rc.
