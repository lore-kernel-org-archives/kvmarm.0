From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v13 10/12] qdev: check callback takes the property child
 as third argument
Date: Wed, 29 Apr 2015 13:10:32 +0200
Message-ID: <5540BC28.7070106@linaro.org>
References: <1430239873-31950-1-git-send-email-eric.auger@linaro.org>
 <1430239873-31950-11-git-send-email-eric.auger@linaro.org>
 <554094DF.3010607@redhat.com> <55409830.30303@linaro.org>
 <5540BC98.1010608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FD254EED0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 07:04:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NS80NrZ8crvS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Apr 2015 07:04:48 -0400 (EDT)
Received: from mail-wg0-f42.google.com (mail-wg0-f42.google.com [74.125.82.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5F3F4EECE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 07:04:48 -0400 (EDT)
Received: by wgso17 with SMTP id o17so24283641wgs.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Apr 2015 04:13:12 -0700 (PDT)
In-Reply-To: <5540BC98.1010608@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, eric.auger@st.com, qemu-devel@nongnu.org, alex.williamson@redhat.com, agraf@suse.de, peter.crosthwaite@xilinx.com
Cc: kvmarm@lists.cs.columbia.edu, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 04/29/2015 01:12 PM, Paolo Bonzini wrote:
> I think reverting is better since you need a respin and Peter offered to
> touch the code later.
OK Thanks

Eric
> 
> Paolo
