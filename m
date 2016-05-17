From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Tue, 17 May 2016 09:00:05 +0100
Message-ID: <0b0fb6cc-e208-d3e1-e6f1-9e99ce6a663c@arm.com>
References: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
 <CAMJs5B-dGpg++5__cu2WOp40M0xwQjrPFfGhVhiLvnc6AkGiug@mail.gmail.com>
 <7292cb91-39d9-b859-b219-722db5c5dca4@riken.jp>
 <CAMJs5B_Csdt=BPFc36WtjqVwOdn_4+O6MOKCshEHrmepiEgpxA@mail.gmail.com>
 <90cab3e7-7eb3-cb76-5312-af68ee5af7eb@arm.com>
 <424fb79c-bf73-ba4d-7a66-f7ce72dee897@riken.jp>
 <CAMJs5B85MbBqK8NaDtEvFB5zSwWMFY90t=w=JqAjxA0aHhc+6g@mail.gmail.com>
 <b333057e-3813-bb32-0186-bddfd7689e89@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1535C412DD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2016 03:56:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H6ga8RG9rlTs for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 May 2016 03:56:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0095412A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 May 2016 03:56:55 -0400 (EDT)
In-Reply-To: <b333057e-3813-bb32-0186-bddfd7689e89@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

On 17/05/2016 00:28, Itaru Kitayama wrote:
> The new v4.6 upstream kernel gets to the prompt on Mustang (Rev A3).

I would recommend you to bissect Linux and finger one or multiple 
commits which break booting on your board.

Regards,

-- 
Julien Grall
