From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: kvmarm tags kvm-arm-for-4.2, 4.3, and v4.4-rc6 does not boot on
 Mustang
Date: Sun, 27 Dec 2015 15:33:03 +0100
Message-ID: <20151227143303.GA8044@cbox>
References: <567918E6.8020001@riken.jp> <20151222144135.GB5631@cbox>
 <567D1F65.5040008@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4E0411BE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Dec 2015 09:29:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0U4lBe3PBoz4 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 27 Dec 2015 09:29:45 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C99A4053F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Dec 2015 09:29:44 -0500 (EST)
Received: by mail-wm0-f50.google.com with SMTP id l126so241797191wml.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 27 Dec 2015 06:32:47 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <567D1F65.5040008@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 25, 2015 at 07:50:13PM +0900, Itaru Kitayama wrote:
> Hi Christoffer,
> After some investigations, it seems newer kernels does not boot on the
> Mustang board which I have access (in the Linaro Server Lab).
> 
> I am using the Fedora 23 userland, 4.2.x Fedora kernels do boot, but
> 4.4.x Fedora kernels do not (they are downloaded from the Koji site or
> own-built ones using fedpkg). I am not sure at this moment, the F/W
> is too old or not.
> 
I don't know anything about distro kernels, I only follow mainline and
just booted mainline just fine on my mustang.

-Christoffer
