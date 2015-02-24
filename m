From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 11:59:35 +0000
Message-ID: <20150224115935.GA26241@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ADC6464C9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 06:54:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ng9hPfSnwsJE for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 06:53:58 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0CC4F464C6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 06:53:57 -0500 (EST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
 (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
 by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t1OBxbGg007963
 (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 06:59:38 -0500
Received: from localhost (vpn1-4-197.ams2.redhat.com [10.36.4.197])
 by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id
 t1OBxa8A027137
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 06:59:37 -0500
Content-Disposition: inline
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


https://bugzilla.redhat.com/show_bug.cgi?id=1194366

Has anyone seen this KVM error?  Or have suggestions how to debug it
further?

  kvm [2028]: load/store instruction decoding not implemented

Qemu prints this before crashing:

  error: kvm run failed Function not implemented
  (followed by a register dump)

It happens precisely when the guest loads the crc32-arm64.ko module.

Both the guest and host kernel are 4.0.0-0.rc1.git0.1.fc23.aarch64

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW
